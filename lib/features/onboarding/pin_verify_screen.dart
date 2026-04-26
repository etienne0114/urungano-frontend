import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/storage/hive_storage.dart';
import '../../core/services/api/auth_service.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import '../../core/widgets/pin_pad.dart';
import '../../core/providers/progress_provider.dart';

class PinVerifyScreen extends ConsumerStatefulWidget {
  const PinVerifyScreen({super.key});

  @override
  ConsumerState<PinVerifyScreen> createState() => _PinVerifyScreenState();
}

class _PinVerifyScreenState extends ConsumerState<PinVerifyScreen> {
  final List<String> _digits = [];
  String? _error;
  int _attempts = 0;
  bool _isLoading = false;

  static const _pinLength = 4;
  static const _maxAttempts = 5;

  void _onKey(String digit) {
    if (_isLoading || _digits.length >= _pinLength) return;
    setState(() {
      _digits.add(digit);
      _error = null;
    });
  }

  void _onEnter() {
    if (_isLoading || _digits.length != _pinLength) return;
    _verify();
  }

  void _onDelete() {
    if (_isLoading || _digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  Future<void> _verify() async {
    setState(() => _isLoading = true);

    final entered = _digits.join();
    final userId = HiveStorage.userId;
    bool isValid = false;

    if (userId != null) {
      final token = await AuthService.verifyPin(userId, entered);
      if (token != null) {
        isValid = true;
      } else {
        final hash = sha256.convert(utf8.encode(entered)).toString();
        final stored = HiveStorage.pinHash;
        isValid = hash == stored;
      }
    } else {
      final hash = sha256.convert(utf8.encode(entered)).toString();
      final stored = HiveStorage.pinHash;
      isValid = hash == stored;
    }

    if (!mounted) return;
    final l = AppLocalizations.of(context);
    setState(() => _isLoading = false);

    if (isValid) {
      ref.read(sessionUnlockedProvider.notifier).state = true;
      context.go('/home');
    } else {
      _attempts++;
      setState(() {
        _digits.clear();
        _error = _attempts >= _maxAttempts
            ? l.pinVerifyTooManyAttempts
            : l.pinVerifyAttemptsLeft(_maxAttempts - _attempts);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locked = _attempts >= _maxAttempts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.lock_rounded,
                    color: AppColors.primary, size: 36),
              ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 32),

              Text(l.pinVerifyTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.display().copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ))
                  .animate(delay: 150.ms).fadeIn(duration: 350.ms),

              const SizedBox(height: 12),

              Text(l.pinVerifySubtitleFull,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium().copyWith(
                  color: AppColors.textSecondary,
                ))
                  .animate(delay: 200.ms).fadeIn(duration: 350.ms),

              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (i) {
                  final filled = i < _digits.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.primary : AppColors.divider.withValues(alpha: 0.3),
                      border: Border.all(
                        color: filled ? AppColors.primary : AppColors.divider,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ).animate(delay: 250.ms).fadeIn(duration: 350.ms),

              if (_error != null) ...[
                const SizedBox(height: 24),
                Text(_error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium()
                      .copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              ],

              const SizedBox(height: 48),

              if (!locked)
                PinPad(
                  onKey: _onKey, 
                  onDelete: _onDelete,
                  onEnter: _digits.length == _pinLength ? _onEnter : null,
                )
                    .animate(delay: 300.ms).fadeIn(duration: 350.ms),

              const Spacer(),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
