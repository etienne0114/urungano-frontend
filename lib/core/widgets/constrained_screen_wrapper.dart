import 'package:flutter/material.dart';

/// A wrapper that centers content and constrains its maximum width.
/// Used to maintain a professional, focused layout on wide screens (desktop/web).
class ConstrainedScreenWrapper extends StatelessWidget {
  const ConstrainedScreenWrapper({
    required this.child,
    this.maxWidth = 600,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
