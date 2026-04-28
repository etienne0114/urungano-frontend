import 'package:flutter/material.dart';

class Circle {
  const Circle({
    required this.id,
    required this.slug,
    required this.name,
    required this.topic,
    required this.onlineCount,
    required this.messageCount,
    required this.emoji,
    required this.color,
    required this.bgColor,
    required this.moderator,
  });

  final String id;
  final String slug;
  final String name;
  final String topic;
  final int onlineCount;
  final int messageCount;
  final String emoji;
  final String color;
  final String bgColor;
  final String moderator;
}

class Debate {
  const Debate({
    required this.id,
    required this.question,
    required this.yesPercent,
    required this.noPercent,
    required this.totalVotes,
    required this.tag,
    required this.heatColor,
    this.myVote,
  });

  final String id;
  final String question;
  final int yesPercent;
  final int noPercent;
  final int totalVotes;
  final String tag;
  final String heatColor;
  final bool? myVote;
}

class AnonQuestion {
  const AnonQuestion({
    required this.id,
    required this.text,
    required this.answered,
    this.reply,
    this.answeredBy,
    required this.createdAt,
  });

  final String id;
  final String text;
  final bool answered;
  final String? reply;
  final String? answeredBy;
  final DateTime createdAt;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.who,
    required this.avatarSeed,
    required this.isYou,
    required this.isEducator,
    required this.text,
    required this.createdAt,
    this.lang = 'rw',
  });

  final String id;
  final String who;
  final String avatarSeed;
  final bool isYou;
  final bool isEducator;
  final String text;
  final DateTime createdAt;
  final String lang;
}

class DirectMessage {
  const DirectMessage({
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
}
