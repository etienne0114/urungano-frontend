import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Numeric PIN pad shared by [PinSetupScreen] and [PinVerifyScreen].
class PinPad extends StatelessWidget {
  const PinPad({
    required this.onKey,
    required this.onDelete,
    this.onEnter,
    super.key,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onDelete;
  final VoidCallback? onEnter;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['enter', '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key == 'enter') {
                final active = onEnter != null;
                return _KeyButton(
                  onTap: active ? onEnter! : () {},
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: active ? AppColors.primary : AppColors.divider.withValues(alpha: 0.5),
                    size: 26,
                  ),
                );
              }
              if (key == 'del') {
                return _KeyButton(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                );
              }
              return _KeyButton(
                onTap: () => onKey(key),
                child: Text(key, style: AppTextStyles.headline()),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink10.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
