import 'package:flutter/material.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class _Lang {
  const _Lang({required this.code, required this.name, required this.flag});
  final String code, name, flag;
}

/// Three language chips (RW / EN / FR). Active one is highlighted dark.
class LanguageChipSelector extends StatelessWidget {
  const LanguageChipSelector({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final langs = [
      _Lang(code: 'rw', name: l.langKinyarwanda, flag: '🇷🇼'),
      _Lang(code: 'en', name: l.langEnglish, flag: '🇬🇧'),
      _Lang(code: 'fr', name: l.langFrench, flag: '🇫🇷'),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: langs.map((lang) {
          final active = lang.code == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(lang.code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? AppColors.darkSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(lang.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(
                      lang.name,
                      style: AppTextStyles.caption().copyWith(
                        color:
                            active ? AppColors.white : AppColors.textSecondary,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
