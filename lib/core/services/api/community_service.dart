import 'package:dio/dio.dart';
import '../../data/community_data.dart';
import '../connectivity_service.dart';
import '../storage/hive_storage.dart';
import 'api_client.dart';

/// Shapes returned by the backend community endpoints.
class CircleDto {
  const CircleDto({
    required this.id,
    required this.slug,
    required this.name,
    required this.topic,
    required this.emoji,
    required this.color,
    required this.bgColor,
    required this.moderator,
    required this.onlineCount,
    required this.messageCount,
  });

  final String id;
  final String slug;
  final String name;
  final String topic;
  final String emoji;
  final String color;
  final String bgColor;
  final String moderator;
  final int onlineCount;
  final int messageCount;

  factory CircleDto.fromJson(Map<String, dynamic> j) => CircleDto(
        id:           j['id'] as String,
        slug:         j['slug'] as String,
        name:         j['name'] as String,
        topic:        j['topic'] as String,
        emoji:        j['emoji'] as String,
        color:        j['color'] as String,
        bgColor:      j['bgColor'] as String,
        moderator:    j['moderator'] as String,
        onlineCount:  (j['onlineCount'] as num?)?.toInt() ?? 0,
        messageCount: (j['messageCount'] as num?)?.toInt() ?? 0,
      );
}

class MessageDto {
  const MessageDto({
    required this.id,
    required this.who,
    required this.avatarSeed,
    required this.text,
    required this.isYou,
    required this.isEducator,
    required this.lang,
    required this.createdAt,
  });

  final String   id;
  final String   who;
  final String   avatarSeed;
  final String   text;
  final bool     isYou;
  final bool     isEducator;
  final String   lang;
  final DateTime createdAt;

  factory MessageDto.fromJson(Map<String, dynamic> j) => MessageDto(
        id:         j['id'] as String,
        who:        j['who'] as String,
        avatarSeed: (j['avatarSeed'] as String?) ?? '01',
        text:       j['text'] as String,
        isYou:      (j['isYou'] as bool?) ?? false,
        isEducator: (j['isEducator'] as bool?) ?? false,
        lang:       (j['lang'] as String?) ?? 'rw',
        createdAt:  DateTime.parse(j['createdAt'] as String),
      );
}

class DebateDto {
  const DebateDto({
    required this.id,
    required this.question,
    required this.tag,
    required this.heatColor,
    required this.yesPercent,
    required this.noPercent,
    required this.totalVotes,
    required this.myVote,
  });

  final String  id;
  final String  question;
  final String  tag;
  final String  heatColor;
  final int     yesPercent;
  final int     noPercent;
  final int     totalVotes;
  final bool?   myVote;

  factory DebateDto.fromJson(Map<String, dynamic> j) => DebateDto(
        id:          j['id'] as String,
        question:    j['question'] as String,
        tag:         j['tag'] as String,
        heatColor:   j['heatColor'] as String,
        yesPercent:  (j['yesPercent'] as num).toInt(),
        noPercent:   (j['noPercent'] as num).toInt(),
        totalVotes:  (j['totalVotes'] as num).toInt(),
        myVote:      j['myVote'] as bool?,
      );

  DebateDto copyWith({int? yesPercent, int? noPercent, int? totalVotes, bool? myVote}) =>
      DebateDto(
        id:         id,
        question:   question,
        tag:        tag,
        heatColor:  heatColor,
        yesPercent: yesPercent ?? this.yesPercent,
        noPercent:  noPercent  ?? this.noPercent,
        totalVotes: totalVotes ?? this.totalVotes,
        myVote:     myVote     ?? this.myVote,
      );
}

class AnonQuestionDto {
  const AnonQuestionDto({
    required this.id,
    required this.text,
    required this.answered,
    required this.reply,
    required this.answeredBy,
    required this.createdAt,
  });

  final String   id;
  final String   text;
  final bool     answered;
  final String?  reply;
  final String?  answeredBy;
  final DateTime createdAt;

  factory AnonQuestionDto.fromJson(Map<String, dynamic> j) => AnonQuestionDto(
        id:         j['id'] as String,
        text:       j['text'] as String,
        answered:   (j['answered'] as bool?) ?? false,
        reply:      j['reply'] as String?,
        answeredBy: j['answeredBy'] as String?,
        createdAt:  DateTime.parse(j['createdAt'] as String),
      );
}

class DirectMessageDto {
  const DirectMessageDto({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.text,
    required this.lang,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String text;
  final String lang;
  final bool isRead;
  final DateTime createdAt;

  factory DirectMessageDto.fromJson(Map<String, dynamic> j) => DirectMessageDto(
        id:           j['id'] as String,
        senderId:     j['senderId'] as String,
        senderName:   j['senderName'] as String,
        receiverId:   j['receiverId'] as String,
        receiverName: j['receiverName'] as String,
        text:         j['text'] as String,
        lang:         (j['lang'] as String?) ?? 'rw',
        isRead:       (j['isRead'] as bool?) ?? false,
        createdAt:    DateTime.parse(j['createdAt'] as String),
      );
}

/// All community endpoints, wired to the real NestJS backend.
/// Falls back to Hive cache when offline.
class CommunityService {
  CommunityService._();

  static const String _base = '/community';

  // ── Circles ────────────────────────────────────────────────────────────────

  static Future<List<CircleDto>> getCircles() async {
    final online = await ConnectivityService.check();
    if (!online) {
      final cached = _cachedCircles();
      return cached.isNotEmpty ? cached : _staticCircles();
    }

    try {
      final res = await ApiClient.instance.get<Map<String, dynamic>>('$_base/circles');
      final list = (ApiClient.staticUnwrap<List<dynamic>>(res)).cast<Map<String, dynamic>>();
      final circles = list.map(CircleDto.fromJson).toList();
      if (circles.isEmpty) return _staticCircles();
      HiveStorage.saveCommunityCircles(list);
      return circles;
    } on DioException {
      final cached = _cachedCircles();
      return cached.isNotEmpty ? cached : _staticCircles();
    }
  }

  static List<CircleDto> _cachedCircles() {
    final raw = HiveStorage.loadCommunityCircles();
    return raw.map(CircleDto.fromJson).toList();
  }

  static List<CircleDto> _staticCircles() => kCircles
      .map((c) => CircleDto(
            id: c.id,
            slug: c.slug,
            name: c.name,
            topic: c.topic,
            emoji: c.emoji,
            color: c.color,
            bgColor: c.bgColor,
            moderator: c.moderator,
            onlineCount: c.onlineCount,
            messageCount: c.messageCount,
          ))
      .toList();

  // ── Messages ───────────────────────────────────────────────────────────────

  static Future<List<MessageDto>> getMessages(String circleSlug,
      {int limit = 50}) async {
    final online = await ConnectivityService.check();
    if (!online) {
      final cached = _cachedMessages(circleSlug);
      return cached.isNotEmpty ? cached : _staticMessages(circleSlug);
    }

    try {
      final res = await ApiClient.instance.get<Map<String, dynamic>>(
        '$_base/circles/$circleSlug/messages',
        queryParameters: {'limit': limit},
      );
      final list =
          (ApiClient.staticUnwrap<List<dynamic>>(res)).cast<Map<String, dynamic>>();
      final messages = list.map(MessageDto.fromJson).toList();
      if (messages.isEmpty) return _staticMessages(circleSlug);
      HiveStorage.saveCommunityMessages(circleSlug, list);
      return messages;
    } on DioException {
      final cached = _cachedMessages(circleSlug);
      return cached.isNotEmpty ? cached : _staticMessages(circleSlug);
    }
  }

  static List<MessageDto> _cachedMessages(String circleSlug) {
    final raw = HiveStorage.loadCommunityMessages(circleSlug);
    return raw.map(MessageDto.fromJson).toList();
  }

  static List<MessageDto> _staticMessages(String circleSlug) =>
      (kCircleMessages[circleSlug] ?? [])
          .map((m) => MessageDto(
                id: m.id,
                who: m.who,
                avatarSeed: m.avatarSeed,
                text: m.text,
                isYou: m.isYou,
                isEducator: m.isEducator,
                lang: m.lang,
                createdAt: m.createdAt,
              ))
          .toList();

  static Future<MessageDto> sendMessage(
      String circleSlug, String text, String lang) async {
    final online = await ConnectivityService.check();
    if (!online) {
      // Queue for flush when reconnected; return an optimistic local message
      await HiveStorage.queuePendingMessage(circleSlug, {
        'text': text,
        'lang': lang,
        'queuedAt': DateTime.now().toIso8601String(),
      });
      return MessageDto(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        who: HiveStorage.userId ?? 'me',
        avatarSeed: '01',
        text: text,
        isYou: true,
        isEducator: false,
        lang: lang,
        createdAt: DateTime.now(),
      );
    }
    try {
      final res = await ApiClient.instance.post<Map<String, dynamic>>(
        '$_base/circles/$circleSlug/messages',
        data: {'text': text, 'lang': lang},
      );
      return MessageDto.fromJson(
          ApiClient.staticUnwrap<Map<String, dynamic>>(res));
    } on DioException {
      // If the request fails mid-flight, queue it
      await HiveStorage.queuePendingMessage(circleSlug, {
        'text': text,
        'lang': lang,
        'queuedAt': DateTime.now().toIso8601String(),
      });
      return MessageDto(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        who: HiveStorage.userId ?? 'me',
        avatarSeed: '01',
        text: text,
        isYou: true,
        isEducator: false,
        lang: lang,
        createdAt: DateTime.now(),
      );
    }
  }

  // ── Debates ────────────────────────────────────────────────────────────────

  static Future<List<DebateDto>> getDebates() async {
    final online = await ConnectivityService.check();
    if (!online) {
      final cached = _cachedDebates();
      return cached.isNotEmpty ? cached : _staticDebates();
    }

    try {
      final res =
          await ApiClient.instance.get<Map<String, dynamic>>('$_base/debates');
      final list =
          (ApiClient.staticUnwrap<List<dynamic>>(res)).cast<Map<String, dynamic>>();
      final debates = list.map(DebateDto.fromJson).toList();
      if (debates.isEmpty) return _staticDebates();
      HiveStorage.saveCommunityDebates(list);
      return debates;
    } on DioException {
      final cached = _cachedDebates();
      return cached.isNotEmpty ? cached : _staticDebates();
    }
  }

  static List<DebateDto> _cachedDebates() {
    final raw = HiveStorage.loadCommunityDebates();
    return raw.map(DebateDto.fromJson).toList();
  }

  static List<DebateDto> _staticDebates() => kDebates
      .map((d) => DebateDto(
            id: d.id,
            question: d.question,
            tag: d.tag,
            heatColor: d.heatColor,
            yesPercent: d.yesPercent,
            noPercent: d.noPercent,
            totalVotes: d.totalVotes,
            myVote: d.myVote,
          ))
      .toList();

  static Future<DebateDto> castVote(String debateId, bool vote) async {
    final online = await ConnectivityService.check();
    if (!online) {
      // Votes require connectivity — the provider already applies optimistic
      // local state, so just throw so the provider can show an offline notice.
      throw DioException(
        requestOptions: RequestOptions(path: '$_base/debates/$debateId/vote'),
        type: DioExceptionType.connectionError,
        message: 'offline',
      );
    }
    final res = await ApiClient.instance.post<Map<String, dynamic>>(
      '$_base/debates/$debateId/vote',
      data: {'vote': vote},
    );
    return DebateDto.fromJson(ApiClient.staticUnwrap<Map<String, dynamic>>(res));
  }

  // ── Anonymous questions ────────────────────────────────────────────────────

  static Future<List<AnonQuestionDto>> getQuestions() async {
    final online = await ConnectivityService.check();
    if (!online) {
      final cached = _cachedQuestions();
      return cached.isNotEmpty ? cached : _staticQuestions();
    }

    try {
      final res = await ApiClient.instance
          .get<Map<String, dynamic>>('$_base/questions');
      final list =
          (ApiClient.staticUnwrap<List<dynamic>>(res)).cast<Map<String, dynamic>>();
      final questions = list.map(AnonQuestionDto.fromJson).toList();
      if (questions.isEmpty) return _staticQuestions();
      HiveStorage.saveCommunityQuestions(list);
      return questions;
    } on DioException {
      final cached = _cachedQuestions();
      return cached.isNotEmpty ? cached : _staticQuestions();
    }
  }

  static List<AnonQuestionDto> _cachedQuestions() {
    final raw = HiveStorage.loadCommunityQuestions();
    return raw.map(AnonQuestionDto.fromJson).toList();
  }

  static List<AnonQuestionDto> _staticQuestions() => kAnonQuestions
      .map((q) => AnonQuestionDto(
            id: q.id,
            text: q.text,
            answered: q.answered,
            reply: q.reply,
            answeredBy: q.answeredBy,
            createdAt: q.createdAt,
          ))
      .toList();

  static Future<AnonQuestionDto> submitQuestion(String text) async {
    final online = await ConnectivityService.check();
    if (!online) {
      await HiveStorage.queuePendingQuestion({
        'text': text,
        'queuedAt': DateTime.now().toIso8601String(),
      });
      return AnonQuestionDto(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        answered: false,
        reply: null,
        answeredBy: null,
        createdAt: DateTime.now(),
      );
    }
    try {
      final res = await ApiClient.instance.post<Map<String, dynamic>>(
        '$_base/questions',
        data: {'text': text},
      );
      return AnonQuestionDto.fromJson(
          ApiClient.staticUnwrap<Map<String, dynamic>>(res));
    } on DioException {
      await HiveStorage.queuePendingQuestion({
        'text': text,
        'queuedAt': DateTime.now().toIso8601String(),
      });
      return AnonQuestionDto(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        answered: false,
        reply: null,
        answeredBy: null,
        createdAt: DateTime.now(),
      );
    }
  }

  static Future<AnonQuestionDto> answerQuestion(
      String questionId, String reply) async {
    final res = await ApiClient.instance.patch<Map<String, dynamic>>(
      '$_base/questions/$questionId/answer',
      data: {'reply': reply},
    );
    return AnonQuestionDto.fromJson(
        ApiClient.staticUnwrap<Map<String, dynamic>>(res));
  }

  // ── Direct messages ────────────────────────────────────────────────────────

  static Future<List<DirectMessageDto>> getDirectMessages(
      String otherUserId) async {
    final res = await ApiClient.instance
        .get<Map<String, dynamic>>('$_base/direct/$otherUserId');
    final list = (ApiClient.staticUnwrap<List<dynamic>>(res))
        .cast<Map<String, dynamic>>();
    return list.map(DirectMessageDto.fromJson).toList();
  }

  static Future<DirectMessageDto> sendDirectMessage(
      String receiverId, String text,
      {String? lang}) async {
    final res = await ApiClient.instance.post<Map<String, dynamic>>(
      '$_base/direct',
      data: {'receiverId': receiverId, 'text': text, 'lang': lang},
    );
    return DirectMessageDto.fromJson(
        ApiClient.staticUnwrap<Map<String, dynamic>>(res));
  }

  // ── Featured ──────────────────────────────────────────────────────────────

  static Future<CircleDto> getWeeklyCircle() async {
    final res =
        await ApiClient.instance.get<Map<String, dynamic>>('$_base/weekly-circle');
    return CircleDto.fromJson(ApiClient.staticUnwrap<Map<String, dynamic>>(res));
  }
}
