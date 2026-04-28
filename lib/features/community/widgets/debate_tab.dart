import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/services/api/community_service.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';

class DebateTab extends ConsumerWidget {
  const DebateTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debatesAsync = ref.watch(debatesProvider);
    final settings = ref.watch(settingsProvider);
    final scale = settings.largerText ? 1.18 : 1.0;

    return debatesAsync.when(
      data: (debates) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: debates.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _PollCard(
            debate: debates[i],
            scale: scale,
            onVote: (val) =>
                ref.read(debatesProvider.notifier).vote(debates[i].id, val),
          )
              .animate(delay: (i * 100).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
          child: Text(AppLocalizations.of(context).communityLoadErrorDebates)),
    );
  }
}

class _PollCard extends StatelessWidget {
  const _PollCard({
    required this.debate,
    required this.scale,
    required this.onVote,
  });

  final DebateDto debate;
  final double scale;
  final Function(bool) onVote;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = Color(
        int.parse('FF${debate.heatColor.replaceFirst('#', '')}', radix: 16));

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                    '${debate.tag.toUpperCase()} · ${l.communityTabDebate.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(scaleFactor: scale).copyWith(
                        fontSize: 9,
                        color: AppColors.ink60,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Text(l.communityVotes(debate.totalVotes),
                  style: AppTextStyles.caption(scaleFactor: scale)
                      .copyWith(fontSize: 10, color: AppColors.ink60)),
            ],
          ),
          const SizedBox(height: 16),
          Text(debate.question,
              style: AppTextStyles.headline(scaleFactor: scale).copyWith(
                  fontSize: 22, fontWeight: FontWeight.w700, height: 1.2)),
          const SizedBox(height: 28),

          // Combined Progress Bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  if (debate.yesPercent > 0)
                    Expanded(
                      flex: debate.yesPercent.toInt(),
                      child: Container(
                        color: color,
                        alignment: Alignment.center,
                        child: Text(l.communityVoteYesPct(debate.yesPercent),
                            style: AppTextStyles.label(scaleFactor: scale)
                                .copyWith(color: Colors.white, fontSize: 11)),
                      ),
                    ),
                  if (debate.noPercent > 0)
                    Expanded(
                      flex: debate.noPercent.toInt(),
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(l.communityVoteNoPct(debate.noPercent),
                            style: AppTextStyles.label(scaleFactor: scale)
                                .copyWith(
                                    color: AppColors.textPrimary, fontSize: 11)),
                      ),
                    ),
                  if (debate.yesPercent == 0 && debate.noPercent == 0)
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('Be the first to vote', 
                          style: AppTextStyles.caption(scaleFactor: scale)),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _VoteButton(
                    label: l.communityVoteYes,
                    color: color,
                    isActive: debate.myVote == true,
                    onTap: () => onVote(true),
                    scale: scale),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _VoteButton(
                    label: l.communityVoteNo,
                    color: AppColors.divider2,
                    isActive: debate.myVote == false,
                    onTap: () => onVote(false),
                    scale: scale),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline_rounded,
                  color: AppColors.ink40, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton(
      {required this.label,
      required this.color,
      required this.onTap,
      required this.scale,
      required this.isActive});
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double scale;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : AppColors.white,
          border: Border.all(
              color: isActive ? color : AppColors.divider2, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(label,
              style: AppTextStyles.label(scaleFactor: scale).copyWith(
                  color: isActive ? color : AppColors.ink60,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
