import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/services/api/community_service.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';
import 'package:urungano/core/widgets/voice_mic_button.dart';

class AskAnonTab extends ConsumerStatefulWidget {
  const AskAnonTab({super.key});

  @override
  ConsumerState<AskAnonTab> createState() => _AskAnonTabState();
}

class _AskAnonTabState extends ConsumerState<AskAnonTab> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.length < 10) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(anonQuestionsProvider.notifier).submit(text);
      _controller.clear();
      if (mounted) {
        final l = AppLocalizations.of(context);
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.communitySubmitSuccess)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showAskDialog() {
    final l = AppLocalizations.of(context);
    final lang = ref.read(settingsProvider).language;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l.communityAskDialogTitle,
            style: AppTextStyles.title()
                .copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.communityAskDialogBody,
                style:
                    AppTextStyles.caption().copyWith(color: AppColors.ink60)),
            const SizedBox(height: 20),
            // Text field + inline mic button
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: l.communityAskInputHint,
                      hintStyle: AppTextStyles.body()
                          .copyWith(color: AppColors.ink40),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Voice mic — appends spoken text into the field
                VoiceMicButton(
                  languageCode: lang,
                  size: 44,
                  iconSize: 20,
                  onResult: (text, isFinal) {
                    _controller.text = text;
                    _controller.selection = TextSelection.collapsed(
                        offset: text.length);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.mic_none_rounded,
                    size: 12, color: AppColors.ink40),
                const SizedBox(width: 4),
                Text(l.sttTapToSpeak,
                    style: AppTextStyles.caption()
                        .copyWith(color: AppColors.ink40, fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () {
              _submit();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkSurface,
                foregroundColor: Colors.white),
            child: Text(l.submit),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final questionsAsync = ref.watch(anonQuestionsProvider);
    final settings = ref.watch(settingsProvider);
    final scale = settings.largerText ? 1.18 : 1.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Dark Hero Card ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.communityAskHint,
                    style: AppTextStyles.title(scaleFactor: scale).copyWith(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text(l.communityAskPrivacy,
                    style: AppTextStyles.body(scaleFactor: scale)
                        .copyWith(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _showAskDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_circle_outlined, size: 18),
                      const SizedBox(width: 10),
                      Text(l.communityTabAsk,
                          style: AppTextStyles.button(scaleFactor: scale)
                              .copyWith(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 40),
          Text(l.communityRecent,
              style: AppTextStyles.label(scaleFactor: scale).copyWith(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: AppColors.ink60,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),

          // ── Timeline ───────────────────────────────────────────────────────
          questionsAsync.when(
            data: (questions) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, i) => _QuestionCard(
                question: questions[i],
                scale: scale,
              ).animate(delay: (i * 100).ms).fadeIn(duration: 400.ms),
            ),
            loading: () => const Center(
                child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )),
            error: (e, _) => Center(child: Text(l.communityLoadErrorQuestions)),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question, required this.scale});
  final AnonQuestionDto question;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('"${question.text}"',
                    style: AppTextStyles.title(scaleFactor: scale).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
              const SizedBox(width: 12),
              Text(l.communityTimeAgoMin(4),
                  style: AppTextStyles.caption(scaleFactor: scale)
                      .copyWith(color: AppColors.ink40, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          if (question.answered && question.reply != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.sageSoft.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.sage, size: 14),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.body(scaleFactor: scale).copyWith(
                            fontSize: 13, color: AppColors.textPrimary),
                        children: [
                          TextSpan(
                              text:
                                  '${AppLocalizations.of(context).communityAskAnswered} - ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.sage)),
                          TextSpan(text: question.reply),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(AppLocalizations.of(context).communityAskAwaitingFull,
                  style: AppTextStyles.caption(scaleFactor: scale)
                      .copyWith(color: AppColors.ink60, fontSize: 11)),
            ),
        ],
      ),
    );
  }
}
