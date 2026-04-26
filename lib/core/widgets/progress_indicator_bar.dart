import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProgressIndicatorBar extends StatelessWidget {
  const ProgressIndicatorBar({
    required this.value,
    this.color = AppColors.primary,
    this.backgroundColor = AppColors.primaryLight,
    this.height = 4,
    super.key,
  });

  /// 0.0 – 1.0
  final double value;
  final Color  color;
  final Color  backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final total = constraints.maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              Container(
                height: height,
                width: total,
                color: backgroundColor,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                height: height,
                width: total * value.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
