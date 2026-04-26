import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/services/api/community_service.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/providers/progress_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';
import 'package:urungano/core/widgets/voice_mic_button.dart';

class CommunityThreadScreen extends ConsumerStatefulWidget {
  const CommunityThreadScreen({
    required this.circleId,
    this.isEmbedded = false,
    super.key,
  });

  final String circleId;
  final bool isEmbedded;

  @override
  ConsumerState<CommunityThreadScreen> createState() =>
      _CommunityThreadScreenState();
}

class _CommunityThreadScreenState extends ConsumerState<CommunityThreadScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _wasTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTypingChanged);
  }

  void _onTypingChanged() {
    final isTyping = _controller.text.isNotEmpty;
    if (isTyping != _wasTyping) {
      _wasTyping = isTyping;
      ref.read(chatProvider(widget.circleId).notifier).setTyping(isTyping);
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final settings = ref.read(settingsProvider);
    ref
        .read(chatProvider(widget.circleId).notifier)
        .sendMessage(text, settings.language);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final chatState = ref.watch(chatProvider(widget.circleId));
    final circlesAsync = ref.watch(circlesProvider);
    final settings = ref.watch(settingsProvider);
    final scale = settings.largerText ? 1.18 : 1.0;

    final circle = circlesAsync.value?.firstWhere(
      (c) => c.slug == widget.circleId,
      orElse: () => CircleDto(
          id: '',
          slug: widget.circleId,
          name: widget.circleId,
          topic: '',
          emoji: '💬',
          color: '#E85D75',
          bgColor: '#FCE4E8',
          moderator: '',
          onlineCount: 0,
          messageCount: 0),
    );

    final content = Column(
      children: [
        _ThreadHeader(
          circle: circle,
          isEmbedded: widget.isEmbedded,
          scale: scale,
          onlineCount: chatState.onlineCount,
        ),
        const Divider(height: 1, color: AppColors.divider),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: chatState.messages.length,
                itemBuilder: (context, i) => _MessageBubble(
                  message: chatState.messages[i],
                  scale: scale,
                ),
              ),
              if (chatState.isTyping)
                Positioned(
                  bottom: 8,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(l.communityTyping,
                        style: AppTextStyles.caption(scaleFactor: scale)
                            .copyWith(fontStyle: FontStyle.italic)),
                  ).animate().fadeIn().slideY(begin: 0.5, end: 0),
                ),
            ],
          ),
        ),
        _InputBar(
          controller: _controller,
          onSend: _send,
          scale: scale,
          languageCode: ref.read(settingsProvider).language,
        ),
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: content),
    );
  }
}

class _ThreadHeader extends StatelessWidget {
  const _ThreadHeader({
    required this.circle,
    required this.isEmbedded,
    required this.scale,
    required this.onlineCount,
  });

  final CircleDto? circle;
  final bool isEmbedded;
  final double scale;
  final int onlineCount;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border:
            Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          if (!isEmbedded) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 4),
          ],
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
                child: Text(circle?.emoji ?? '💬',
                    style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(circle?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headline(scaleFactor: scale)
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                    '${circle?.topic ?? ''} · ${l.communityModeratedBy(circle?.moderator ?? '')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(scaleFactor: scale).copyWith(
                        color: AppColors.ink60, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.sageSoft.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: AppColors.sage, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                    l.communityOnline(onlineCount > 0
                        ? onlineCount
                        : (circle?.onlineCount ?? 1)),
                    style: AppTextStyles.label(scaleFactor: scale)
                        .copyWith(fontSize: 9, color: AppColors.sage)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.scale});
  final MessageDto message;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isYou = message.isYou;
    final isEducator = message.isEducator;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment:
            isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isYou) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isEducator ? AppColors.sageSoft : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Text(
                      message.avatarSeed.isNotEmpty
                          ? message.avatarSeed
                          : (isEducator ? '👩‍⚕️' : '🌱'),
                      style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isYou)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(message.who,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.title(scaleFactor: scale)
                                  .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                        ),
                        if (isEducator) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.sage,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(l.communityHealthEducator.toUpperCase(),
                                style: AppTextStyles.label(scaleFactor: scale)
                                    .copyWith(
                                        fontSize: 8,
                                        color: Colors.white,
                                        letterSpacing: 0.5)),
                          ),
                        ],
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isYou
                        ? AppColors.darkSurface
                        : (isEducator
                            ? AppColors.sageSoft.withValues(alpha: 0.7)
                            : AppColors.surface.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isYou ? 16 : 4),
                      bottomRight: Radius.circular(isYou ? 4 : 16),
                    ),
                  ),
                  child: Text(message.text,
                      style: AppTextStyles.body(scaleFactor: scale).copyWith(
                        color: isYou ? Colors.white : AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.5,
                      )),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                      isYou ? l.timeAgoJustNow : l.communityTimeAgoMin(2),
                      style: AppTextStyles.caption(scaleFactor: scale)
                          .copyWith(fontSize: 10, color: AppColors.ink40)),
                ),
              ],
            ),
          ),
          if (isYou) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.catMenstrual,
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('🌸', style: TextStyle(fontSize: 18))),
            ),
          ],
        ],
      ),
    );
  }
}

/// Input bar with live STT mic + text field + send button.
/// The mic button transcribes speech directly into the text field in the
/// user's current language (EN / FR / RW).
class _InputBar extends ConsumerStatefulWidget {
  const _InputBar(
      {required this.controller,
      required this.onSend,
      required this.scale,
      required this.languageCode});
  final TextEditingController controller;
  final VoidCallback onSend;
  final double scale;
  final String languageCode;

  @override
  ConsumerState<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends ConsumerState<_InputBar> {
  String _liveTranscript = '';

  void _onVoiceResult(String text, bool isFinal) {
    setState(() => _liveTranscript = isFinal ? '' : text);
    widget.controller.text = text;
    widget.controller.selection =
        TextSelection.collapsed(offset: text.length);
    if (isFinal && text.trim().isNotEmpty) {
      widget.onSend();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live STT partial-result preview
          if (_liveTranscript.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.mic_rounded,
                      size: 12, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _liveTranscript,
                      style: AppTextStyles.bodySmall().copyWith(
                        color: AppColors.primary,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              // Voice mic button (replaces static icon)
              VoiceMicButton(
                languageCode: widget.languageCode,
                onResult: _onVoiceResult,
                size: 44,
                iconSize: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    style: AppTextStyles.body(scaleFactor: widget.scale)
                        .copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l.communitySendHint,
                      hintStyle: AppTextStyles.body(scaleFactor: widget.scale)
                          .copyWith(color: AppColors.ink40, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (_) => widget.onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: widget.onSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                ),
                child: Row(
                  children: [
                    Text(l.submit,
                        style: AppTextStyles.button(scaleFactor: widget.scale)
                            .copyWith(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    const Icon(Icons.send_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
