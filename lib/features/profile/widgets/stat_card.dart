import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Small stat card: icon, bold number, label.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    super.key,
  });

  final String   value;
  final String   label;
  final IconData icon;
  final Color    iconColor;
  final Color    backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.headline().copyWith(fontSize: 20),
            ),
            Text(label, style: AppTextStyles.caption()),
          ],
        ),
      ),
    );
  }
}
