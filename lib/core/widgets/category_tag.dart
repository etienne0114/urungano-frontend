import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_text_styles.dart';

class CategoryTag extends StatelessWidget {
  const CategoryTag({required this.category, super.key});

  final LessonCategory category;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return Text(
      category.localizedLabel(langCode),
      style: AppTextStyles.label().copyWith(color: category.accentColor),
    );
  }
}
