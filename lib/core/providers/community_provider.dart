import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../services/api/api_client.dart';
import '../services/api/community_service.dart';
import '../services/storage/hive_storage.dart';

// ── DATA PROVIDERS ────────────────────────────────────────────────────────────

/// Fetches all available community circles (chat rooms).
final circlesProvider = AsyncNotifierProvider<CirclesNotifier, List<CircleDto>>(CirclesNotifier.new);

class CirclesNotifier extends AsyncNotifier<List<CircleDto>> {
  @override
  Future<List<CircleDto>> build() => CommunityService.getCircles();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => CommunityService.getCircles());
  }
}

/// Fetches all active debates and user votes.
final debatesProvider = AsyncNotifierProvider<DebatesNotifier, List<DebateDto>>(DebatesNotifier.new);

class DebatesNotifier extends AsyncNotifier<List<DebateDto>> {
  @override
  Future<List<DebateDto>> build() => CommunityService.getDebates();

  Future<void> vote(String debateId, bool voteValue) async {
    final previousState = state.value;
    if (previousState == null) return;

    try {
      final updated = await CommunityService.castVote(debateId, voteValue);
      state = AsyncValue.data(
        previousState.map((d) => d.id == debateId ? updated : d).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => CommunityService.getDebates());
  }
}

/// Fetches anonymous Q&A history.
final anonQuestionsProvider = AsyncNotifierProvider<QuestionsNotifier, List<AnonQuestionDto>>(QuestionsNotifier.new);

class QuestionsNotifier extends AsyncNotifier<List<AnonQuestionDto>> {
  @override
  Future<List<AnonQuestionDto>> build() => CommunityService.getQuestions();

  Future<void> submit(String text) async {
    try {
      final newQuestion = await CommunityService.submitQuestion(text);
      final current = state.value ?? [];
      state = AsyncValue.data([newQuestion, ...current]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => CommunityService.getQuestions());
  }
}

// ── REAL-TIME CHAT PROVIDER ───────────────────────────────────────────────────

class ChatState {
  const ChatState({
    this.messages = const [],
    this.onlineCount = 0,
    this.isTyping = false,
    this.isConnected = false,
  });

  final List<MessageDto> messages;
  final int onlineCount;
  final bool isTyping;
  final bool isConnected;

  ChatState copyWith({
    List<MessageDto>? messages,
    int? onlineCount,
    bool? isTyping,
    bool? isConnected,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        onlineCount: onlineCount ?? this.onlineCount,
        isTyping: isTyping ?? this.isTyping,
        isConnected: isConnected ?? this.isConnected,
      );
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, String>(
  (ref, circleSlug) => ChatNotifier(circleSlug),
);

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this.circleSlug) : super(const ChatState()) {
    _init();
  }

  final String circleSlug;
  io.Socket? _socket;

  void _init() {
    final token = HiveStorage.accessToken;
    if (token == null) return;

    final wsUrl = ApiClient.instance.wsBaseUrl;

    _socket = io.io(wsUrl, 
      io.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .enableAutoConnect()
        .build()
    );

    _socket!.onConnect((_) {
      state = state.copyWith(isConnected: true);
      _socket!.emit('joinCircle', {'circleSlug': circleSlug});
    });

    _socket!.onDisconnect((_) {
      state = state.copyWith(isConnected: false);
    });

    _socket!.on('joinedCircle', (data) {
      _loadInitialMessages();
    });

    _socket!.on('newMessage', (data) {
      final msgJson = data['message'] as Map<String, dynamic>;
      final msg = MessageDto.fromJson(msgJson);
      state = state.copyWith(messages: [...state.messages, msg]);
    });

    _socket!.on('onlineCountUpdate', (data) {
      final count = (data['onlineCount'] as num).toInt();
      state = state.copyWith(onlineCount: count);
    });

    _socket!.on('userTyping', (data) {
      // Simplified: if any user is typing, show indicator
      state = state.copyWith(isTyping: data['isTyping'] as bool);
    });
  }

  Future<void> _loadInitialMessages() async {
    try {
      final initial = await CommunityService.getMessages(circleSlug);
      state = state.copyWith(messages: initial);
    } catch (_) {}
  }

  void sendMessage(String text, String lang) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('sendMessage', {
      'circleSlug': circleSlug,
      'message': {'text': text, 'lang': lang},
    });
  }

  void setTyping(bool typing) {
    _socket?.emit('typing', {'circleSlug': circleSlug, 'isTyping': typing});
  }

  @override
  void dispose() {
    _socket?.emit('leaveCircle', {'circleSlug': circleSlug});
    _socket?.dispose();
    super.dispose();
  }
}
