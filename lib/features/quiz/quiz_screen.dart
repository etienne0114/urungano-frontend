import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/providers/settings_provider.dart';

import '../../core/services/api/quiz_service.dart';
import '../../core/services/tts/narration_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import 'widgets/quiz_result_sheet.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _current = 0;
  int? _selected;
  bool _answered = false;
  final List<int> _answers = [];
  List<QuizQuestion> _questions = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final qs = await QuizService.fetchQuestions(widget.lessonId);
    if (mounted)
      setState(() {
        _questions = qs;
        _loading = false;
      });
  }

  QuizQuestion get _question => _questions[_current];
  bool get _isLast => _current >= _questions.length - 1;

  void _select(int idx) {
    if (_answered) return;
    setState(() {
      _selected = idx;
      _answered = true;
    });
  }

  Future<void> _checkAnswer() async {
    if (_selected == null) return;
    _answers.add(_selected!);

    if (_isLast) {
      final qs = _questions;
      final langCode = ref.read(settingsProvider).language;
      int correct = 0;
      for (int i = 0; i < qs.length; i++) {
        if (_answers[i] == qs[i].correctIndex) correct++;
      }
      await ref.read(progressProvider.notifier).recordQuizResult(
            widget.lessonId,
            qs.length,
            correct,
          );
      if (!mounted) return;
      final result = QuizResult(
        totalQuestions: qs.length,
        correctAnswers: correct,
        accuracy: qs.isEmpty ? 0 : correct / qs.length,
        breakdown: qs.asMap().entries.map((e) {
          final q = e.value;
          final sel = _answers[e.key];
          return QuestionBreakdown(
            questionId: q.id,
            questionText: q.questionFor(langCode),
            selectedIndex: sel,
            correctIndex: q.correctIndex!,
            isCorrect: sel == q.correctIndex,
            explanation: q.explanationFor(langCode),
            localizedExplanation: q.localizedExplanation,
          );
        }).toList(),
      );
      await QuizResultSheet.show(context, result);
    } else {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l.quizNoQuestions, style: AppTextStyles.body()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(l.quizBackHome,
                    style: AppTextStyles.button()
                        .copyWith(color: AppColors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final q = _question;
    final questionText = q.questionFor(langCode);
    final options = q.optionsFor(langCode);
    final explanation = q.explanationFor(langCode);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          maxWidth: isWide ? 800 : 600,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // ── Top bar ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 24, color: AppColors.textPrimary),
                      onPressed: () => context.go('/home'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_current + 1) / _questions.length,
                          backgroundColor:
                              AppColors.divider.withValues(alpha: 0.5),
                          color: AppColors.primary,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_current + 1} / ${_questions.length}',
                      style: AppTextStyles.label().copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Context tag ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          l.quizDailyChallenge,
                          style: AppTextStyles.label().copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(key: ValueKey(_current))
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.05, end: 0),
              ),

              const SizedBox(height: 20),

              // ── Question text ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    questionText,
                    style: AppTextStyles.display().copyWith(
                        fontSize: isWide ? 36 : 28,
                        fontWeight: FontWeight.w800),
                  )
                      .animate(key: ValueKey('q-$_current'))
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.05, end: 0),
                ),
              ),

              const SizedBox(height: 32),

              // ── Option list/grid ──────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final option = options[idx];
                      return _OptionTile(
                        letter: ['A', 'B', 'C', 'D'][idx],
                        label: option,
                        selected: _selected == idx,
                        answered: _answered,
                        isCorrect: q.correctIndex == idx,
                        onTap: () => _select(idx),
                      )
                          .animate(
                            key: ValueKey('opt-$_current-$idx'),
                            delay: Duration(milliseconds: 100 + idx * 60),
                          )
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.05, end: 0);
                    },
                  ),
                ),
              ),

              // ── Explanation ──────────────────────────────────
              if (_answered && explanation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.5),
                          width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10)
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.quizExplanation,
                                  style: AppTextStyles.label().copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text(explanation,
                                  style: AppTextStyles.body().copyWith(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.1, end: 0),
                ),

              // ── Bottom bar ───────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                      top: BorderSide(
                          color: AppColors.divider.withValues(alpha: 0.5))),
                ),
                child: Row(
                  children: [
                    // Read aloud
                    GestureDetector(
                      onTap: () => NarrationService.speak(questionText),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up_rounded,
                                size: 18, color: AppColors.textPrimary),
                            const SizedBox(width: 10),
                            Text(l.quizReadAloud,
                                style: AppTextStyles.label().copyWith(
                                    fontSize: 11, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Check answer / Next
                    GestureDetector(
                      onTap: _answered ? _checkAnswer : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: _answered
                              ? AppColors.darkSurface
                              : AppColors.divider.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            if (_answered)
                              BoxShadow(
                                  color: AppColors.darkSurface
                                      .withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isLast ? l.quizSeeResults : l.quizNextQuestion,
                              style: AppTextStyles.button().copyWith(
                                color: _answered
                                    ? AppColors.white
                                    : AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded,
                                size: 18,
                                color: _answered
                                    ? AppColors.white
                                    : AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter,
    required this.label,
    required this.selected,
    required this.answered,
    required this.isCorrect,
    required this.onTap,
  });

  final String letter;
  final String label;
  final bool selected;
  final bool answered;
  final bool isCorrect;
  final VoidCallback onTap;

  Color _bg() {
    if (!answered)
      return selected
          ? AppColors.primaryLight.withValues(alpha: 0.3)
          : AppColors.white;
    if (isCorrect) return const Color(0xFFE8F5E9);
    if (selected) return const Color(0xFFFFEBEE);
    return AppColors.white;
  }

  Color _border() {
    if (!answered)
      return selected
          ? AppColors.primary
          : AppColors.divider.withValues(alpha: 0.5);
    if (isCorrect) return const Color(0xFF4CAF50);
    if (selected) return AppColors.primary;
    return AppColors.divider.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: answered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: _bg(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border(), width: 2),
          boxShadow: [
            if (selected && !answered)
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: answered && isCorrect
                    ? const Color(0xFF4CAF50)
                    : answered && selected
                        ? AppColors.primary
                        : selected
                            ? AppColors.primary
                            : AppColors.divider.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(letter,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: (selected || (answered && isCorrect))
                          ? AppColors.white
                          : AppColors.textSecondary,
                    )),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label,
                  style: AppTextStyles.body().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            if (answered && isCorrect)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF4CAF50), size: 24),
            if (answered && selected && !isCorrect)
              const Icon(Icons.cancel_rounded,
                  color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
