import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';

class EducatorPanelScreen extends ConsumerWidget {
  const EducatorPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final questions = ref.watch(anonQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Educator Panel', style: AppTextStyles.title().copyWith(fontSize: 18)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: questions.when(
        data: (list) {
          final pending = list.where((q) => !q.answered).toList();
          if (pending.isEmpty) {
            return Center(child: Text('All caught up!', style: AppTextStyles.body()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: pending.length,
            itemBuilder: (context, i) => _QuestionCard(q: pending[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _QuestionCard extends ConsumerStatefulWidget {
  const _QuestionCard({required this.q});
  final AnonQuestionDto q;

  @override
  ConsumerState<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<_QuestionCard> {
  final _controller = TextEditingController();
  bool _submitting = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await CommunityService.answerQuestion(widget.q.id, _controller.text.trim());
      ref.invalidate(anonQuestionsProvider);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.q.text, style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                fillColor: AppColors.background,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _submitting 
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Reply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
