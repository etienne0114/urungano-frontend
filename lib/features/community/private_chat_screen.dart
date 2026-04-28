import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/services/api/community_service.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';
import 'package:urungano/core/widgets/voice_mic_button.dart';

class PrivateChatScreen extends ConsumerStatefulWidget {
  const PrivateChatScreen({
    required this.otherUserId,
    required this.otherUserName,
    super.key,
  });

  final String otherUserId;
  final String otherUserName;

  @override
  ConsumerState<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends ConsumerState<PrivateChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final lang = ref.read(settingsProvider).language;
    ref.read(directMessagesProvider(widget.otherUserId).notifier).send(text, lang);
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
    final messages = ref.watch(directMessagesProvider(widget.otherUserId));
    final scale = ref.watch(settingsProvider).largerText ? 1.18 : 1.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUserName,
                style: AppTextStyles.title(scaleFactor: scale).copyWith(
                    fontSize: 16, fontWeight: FontWeight.w800)),
            Text(l.communityPrivateChat,
                style: AppTextStyles.caption(scaleFactor: scale).copyWith(
                    color: AppColors.sage, fontWeight: FontWeight.w600)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isMe = m.senderId != widget.otherUserId;
                return _DMBubble(m: m, isMe: isMe, scale: scale);
              },
            ),
          ),
          _buildInputBar(l, scale),
        ],
      ),
    );
  }

  Widget _buildInputBar(AppLocalizations l, double scale) {
    final lang = ref.read(settingsProvider).language;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          VoiceMicButton(
            languageCode: lang,
            onResult: (text, isFinal) {
              _controller.text = text;
              if (isFinal && text.trim().isNotEmpty) _send();
            },
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
                controller: _controller,
                style: AppTextStyles.body(scaleFactor: scale).copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: l.communitySendHint,
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _send,
            icon: const Icon(Icons.send_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _DMBubble extends StatelessWidget {
  const _DMBubble({required this.m, required this.isMe, required this.scale});
  final DirectMessageDto m;
  final bool isMe;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMe ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Text(m.text,
                style: AppTextStyles.body(scaleFactor: scale).copyWith(
                  color: isMe ? Colors.white : AppColors.textPrimary,
                  fontSize: 14,
                )),
          ),
        ],
      ),
    );
  }
}
