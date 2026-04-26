import 'package:flutter/material.dart';

class Circle {
  const Circle({
    required this.id,
    required this.name,
    required this.topic,
    required this.onlineCount,
    required this.lastMessage,
    required this.emoji,
    required this.color,
    required this.bgColor,
    this.moderator = 'Nurse Aline',
  });

  final String id;
  final String name;
  final String topic;
  final int onlineCount;
  final String lastMessage;
  final String emoji;
  final Color color;
  final Color bgColor;
  final String moderator;
}

class Debate {
  const Debate({
    required this.question,
    required this.yesPercent,
    required this.votes,
    required this.tag,
    required this.heatColor,
  });

  final String question;
  final int yesPercent;
  final int votes;
  final String tag;
  final Color heatColor;

  int get noPercent => 100 - yesPercent;
}

class AnonQuestion {
  const AnonQuestion({
    required this.id,
    required this.text,
    required this.answered,
    this.reply,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool answered;
  final String? reply;
  final String timestamp;
}

class ChatMessage {
  const ChatMessage({
    required this.who,
    required this.avatarEmoji,
    required this.isYou,
    required this.isNurse,
    required this.text,
    required this.timestamp,
    this.lang = 'rw',
  });

  final String who;
  final String avatarEmoji;
  final bool isYou;
  final bool isNurse;
  final String text;
  final String timestamp;
  final String lang;
}
