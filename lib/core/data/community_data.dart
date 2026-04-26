import 'package:flutter/material.dart';
import '../models/community.dart';

// ── Circles ───────────────────────────────────────────────────────────────────

const List<Circle> kCircles = [
  Circle(
    id: 'cycle_talk',
    name: 'Cycle talk',
    topic: 'Menstrual health',
    onlineCount: 34,
    lastMessage: 'Is spotting between periods normal?',
    emoji: '🌸',
    color: Color(0xFFE85D75),    // rose
    bgColor: Color(0xFFFCE4E8),  // rose-soft
    moderator: 'Nurse Aline',
  ),
  Circle(
    id: 'hiv_testing',
    name: 'HIV & testing',
    topic: 'HIV prevention',
    onlineCount: 21,
    lastMessage: 'Where can I get tested for free in Kigali?',
    emoji: '💊',
    color: Color(0xFF7FA99B),    // sage
    bgColor: Color(0xFFD4E3DC), // sage-soft
    moderator: 'Dr. Emmanuel',
  ),
  Circle(
    id: 'know_your_body',
    name: 'Know your body',
    topic: 'Reproductive anatomy',
    onlineCount: 18,
    lastMessage: 'What does the cervix actually do?',
    emoji: '💡',
    color: Color(0xFFE8A87C),    // amber
    bgColor: Color(0xFFFADFC8), // peach-soft
    moderator: 'Nurse Aline',
  ),
  Circle(
    id: 'relationships',
    name: 'Relationships',
    topic: 'Healthy relationships',
    onlineCount: 54,
    lastMessage: 'How do you set boundaries with a partner?',
    emoji: '💬',
    color: Color(0xFF4A2F37),    // plum-2
    bgColor: Color(0xFFF8EADA), // cream-2
    moderator: 'Counsellor Marie',
  ),
];

// ── Debates ───────────────────────────────────────────────────────────────────

const List<Debate> kDebates = [
  Debate(
    question: 'Is it normal to skip periods sometimes?',
    yesPercent: 73,
    votes: 412,
    tag: 'Menstrual health',
    heatColor: Color(0xFFE85D75), // rose
  ),
  Debate(
    question: 'Can HIV be transmitted through saliva?',
    yesPercent: 22,
    votes: 289,
    tag: 'HIV prevention',
    heatColor: Color(0xFF7FA99B), // sage
  ),
  Debate(
    question: 'Should sex ed be taught in secondary school?',
    yesPercent: 88,
    votes: 631,
    tag: 'Education',
    heatColor: Color(0xFFF4B860), // sun
  ),
];

// ── Anonymous questions ───────────────────────────────────────────────────────

const List<AnonQuestion> kAnonQuestions = [
  AnonQuestion(
    id: 'q1',
    text: 'I\'ve been having very painful cramps — is this endometriosis?',
    answered: true,
    reply:
        'Painful periods can have many causes. Endometriosis is one, but dysmenorrhea (primary painful periods) is more common. Please see a healthcare provider to rule out conditions. In the meantime, ibuprofen and heat pads can help manage pain.',
    timestamp: '2h ago',
  ),
  AnonQuestion(
    id: 'q2',
    text: 'Can you get pregnant the first time you have sex?',
    answered: true,
    reply:
        'Yes, absolutely. Pregnancy can occur any time unprotected sex happens, including the first time. There is no "safe" first time without contraception.',
    timestamp: '5h ago',
  ),
  AnonQuestion(
    id: 'q3',
    text: 'How do I know if I need to get tested for STIs?',
    answered: false,
    timestamp: '1d ago',
  ),
];

// ── Chat messages per circle ──────────────────────────────────────────────────

const Map<String, List<ChatMessage>> kCircleMessages = {
  'cycle_talk': [
    ChatMessage(
      who: 'Nurse Aline',
      avatarEmoji: '👩‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'Welcome everyone! This is a safe space to ask questions about your menstrual cycle. No question is too small.',
      timestamp: '10:02',
    ),
    ChatMessage(
      who: 'Amina',
      avatarEmoji: '🌸',
      isYou: false,
      isNurse: false,
      text: 'Is spotting between periods something to worry about?',
      timestamp: '10:14',
    ),
    ChatMessage(
      who: 'Nurse Aline',
      avatarEmoji: '👩‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'Occasional spotting can be normal, especially around ovulation. But if it happens often or is heavy, it\'s worth seeing a provider.',
      timestamp: '10:17',
    ),
    ChatMessage(
      who: 'You',
      avatarEmoji: '🌙',
      isYou: true,
      isNurse: false,
      text: 'Does stress actually affect your period timing?',
      timestamp: '10:21',
    ),
    ChatMessage(
      who: 'Nurse Aline',
      avatarEmoji: '👩‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'Yes! Stress activates the HPA axis which can suppress GnRH, the hormone that triggers ovulation. High stress can delay or skip your period.',
      timestamp: '10:23',
    ),
  ],
  'hiv_testing': [
    ChatMessage(
      who: 'Dr. Emmanuel',
      avatarEmoji: '👨‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'Free HIV testing is available at all health centres in Rwanda every weekday. Results are confidential.',
      timestamp: '09:30',
    ),
    ChatMessage(
      who: 'Kalisa',
      avatarEmoji: '💊',
      isYou: false,
      isNurse: false,
      text: 'Do you need a referral letter to get tested?',
      timestamp: '09:45',
    ),
    ChatMessage(
      who: 'Dr. Emmanuel',
      avatarEmoji: '👨‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'No referral needed — you can walk in to any community health post or health centre and request a test.',
      timestamp: '09:47',
    ),
    ChatMessage(
      who: 'You',
      avatarEmoji: '🌙',
      isYou: true,
      isNurse: false,
      text: 'How long after exposure should you wait before testing?',
      timestamp: '10:05',
    ),
  ],
  'know_your_body': [
    ChatMessage(
      who: 'Nurse Aline',
      avatarEmoji: '👩‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'Today we\'re exploring reproductive anatomy. Feel free to use the 3D lesson alongside our chat!',
      timestamp: '11:00',
    ),
    ChatMessage(
      who: 'Clarisse',
      avatarEmoji: '💡',
      isYou: false,
      isNurse: false,
      text: 'What does the cervix actually do?',
      timestamp: '11:08',
    ),
    ChatMessage(
      who: 'Nurse Aline',
      avatarEmoji: '👩‍⚕️',
      isYou: false,
      isNurse: true,
      text:
          'The cervix is the lower part of the uterus that opens into the vagina. It produces mucus that changes throughout your cycle, and dilates during childbirth.',
      timestamp: '11:10',
    ),
  ],
  'relationships': [
    ChatMessage(
      who: 'Counsellor Marie',
      avatarEmoji: '💬',
      isYou: false,
      isNurse: true,
      text:
          'Healthy relationships are built on mutual respect, open communication, and shared boundaries. What topics would you like to explore today?',
      timestamp: '08:00',
    ),
    ChatMessage(
      who: 'Fidele',
      avatarEmoji: '🌿',
      isYou: false,
      isNurse: false,
      text: 'How do you set boundaries when your partner doesn\'t respect them?',
      timestamp: '08:22',
    ),
    ChatMessage(
      who: 'Counsellor Marie',
      avatarEmoji: '💬',
      isYou: false,
      isNurse: true,
      text:
          'Start by clearly naming the boundary and the consequence if it\'s crossed. If a partner consistently ignores your limits, that is a serious red flag worth discussing with a trusted adult or counsellor.',
      timestamp: '08:25',
    ),
    ChatMessage(
      who: 'You',
      avatarEmoji: '🌙',
      isYou: true,
      isNurse: false,
      text: 'How do you tell if a relationship is healthy or not?',
      timestamp: '08:31',
    ),
  ],
};
