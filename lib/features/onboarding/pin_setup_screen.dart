import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/services/storage/hive_storage.dart';
import '../../core/services/api/auth_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import '../../core/widgets/pin_pad.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final List<String> _digits = [];
  final TextEditingController _usernameController = TextEditingController();
  List<String>? _firstEntry;
  bool _confirming = false;
  String? _error;
  bool _isLoading = false;

  static const _pinLength = 4;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onKey(String digit) {
    if (_isLoading || _digits.length >= _pinLength) return;
    setState(() {
      _digits.add(digit);
      _error = null;
    });
  }

  void _onEnter() {
    if (_isLoading || _digits.length != _pinLength) return;
    _onComplete();
  }

  void _onDelete() {
    if (_isLoading || _digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  void _onComplete() {
    if (_isLoading || _digits.length != _pinLength) return;
    _savePin(_digits.join());
  }

  bool _isWeakPin(String pin) {
    if (pin.length != 4) return true;
    if (pin == '0000' ||
        pin == '1111' ||
        pin == '2222' ||
        pin == '3333' ||
        pin == '4444' ||
        pin == '5555' ||
        pin == '6666' ||
        pin == '7777' ||
        pin == '8888' ||
        pin == '9999') return true;

    const sequentialAsc = [
      '0123',
      '1234',
      '2345',
      '3456',
      '4567',
      '5678',
      '6789'
    ];
    const sequentialDesc = [
      '3210',
      '4321',
      '5432',
      '6543',
      '7654',
      '8765',
      '9876'
    ];

    if (sequentialAsc.contains(pin) || sequentialDesc.contains(pin))
      return true;

    return false;
  }

  Future<void> _savePin(String pin) async {
    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      final l = AppLocalizations.of(context);
      setState(() {
        _isLoading = false;
        _error = l.profileNameRequired;
        _digits.clear();
        _firstEntry = null;
        _confirming = false;
      });
      return;
    }

    if (!_confirming) {
      // Security check for new users (we'll only enforce it if they end up being new, 
      // but checking now is cleaner)
      if (_isWeakPin(pin)) {
        final l = AppLocalizations.of(context);
        setState(() {
          _isLoading = false;
          _digits.clear();
          _error = l.pinWeakError;
        });
        return;
      }

      // PHASE 1: Try to login (isRegistration: false)
      final result = await ref.read(progressProvider.notifier).signIn(username, pin: pin, isRegistration: false);
      
      if (result.error == null) {
        // MATCH! Existing user logged in successfully.
        await _finalizeAuth(pin);
        return;
      }

      if (result.isNotFound) {
        // NOT FOUND! This is a new user, proceed to confirmation.
        setState(() {
          _isLoading = false;
          _firstEntry = List.from(_digits);
          _digits.clear();
          _confirming = true;
          _error = null;
        });
        return;
      }

      // OTHER ERROR (e.g. 401 Incorrect PIN)
      setState(() {
        _isLoading = false;
        _error = result.error;
        _digits.clear();
      });
    } else {
      // PHASE 2: Confirmation matches, register now
      if (_digits.join() == _firstEntry!.join()) {
        final result = await ref.read(progressProvider.notifier).signIn(username, pin: pin, isRegistration: true);
        
        if (result.error == null) {
          await _finalizeAuth(pin);
        } else {
          setState(() {
            _isLoading = false;
            _error = result.error;
            _digits.clear();
            _firstEntry = null;
            _confirming = false;
          });
        }
      } else {
        setState(() {
          _digits.clear();
          _firstEntry = null;
          _confirming = false;
          _isLoading = false;
          _error = AppLocalizations.of(context).pinMismatch;
        });
      }
    }
  }

  Future<void> _finalizeAuth(String pin) async {
    // Local storage of PIN hash for offline unlock
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await HiveStorage.savePinHash(hash);

    await ref.read(progressProvider.notifier).setHasPIN(true);
    await ref.read(settingsProvider.notifier).setAppLock(true);
    await ref.read(settingsProvider.notifier).completeOnboarding();

    // Unlock session so router allows entry to /home
    ref.read(sessionUnlockedProvider.notifier).state = true;

    if (mounted) context.go('/home');
  }

  Future<void> _skip() async {
    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      setState(() {
        _isLoading = false;
        _error = l.profileNameRequired;
      });
      return;
    }

    final result = await ref.read(progressProvider.notifier).signIn(username, isRegistration: true);
    if (result.error != null) {
      setState(() {
        _isLoading = false;
        _error = result.error;
      });
      return;
    }

    if (!mounted) return;
    await ref.read(settingsProvider.notifier).completeOnboarding();

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = _confirming ? l.pinConfirm : l.pinTitle;
    final subtitle = _confirming ? l.pinVerifySubtitle : l.pinSubtitle;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedScreenWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.lock_rounded,
                      color: AppColors.primary, size: 32),
                ).animate().fadeIn(duration: 400.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: 24),
                Text(title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.display().copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    )).animate(delay: 150.ms).fadeIn(duration: 350.ms),
                const SizedBox(height: 8),
                Text(subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium().copyWith(
                      color: AppColors.textSecondary,
                    )).animate(delay: 200.ms).fadeIn(duration: 350.ms),
                const SizedBox(height: 32),
                if (!_confirming) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: l.pinUsernameHint,
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: AppColors.divider.withValues(alpha: 0.5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: AppColors.divider.withValues(alpha: 0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.person_outline_rounded,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  ).animate(delay: 220.ms).fadeIn(duration: 350.ms),
                  const SizedBox(height: 24),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pinLength, (i) {
                    final filled = i < _digits.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? AppColors.primary
                            : AppColors.divider.withValues(alpha: 0.3),
                        border: Border.all(
                          color: filled ? AppColors.primary : AppColors.divider,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ).animate(delay: 250.ms).fadeIn(duration: 350.ms),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(_error!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall().copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
                const SizedBox(height: 32),
                PinPad(
                  onKey: _onKey,
                  onDelete: _onDelete,
                  onEnter: _digits.length == _pinLength ? _onEnter : null,
                ).animate(delay: 300.ms).fadeIn(duration: 350.ms),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l.pinSkip,
                      style: AppTextStyles.bodyMedium().copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
