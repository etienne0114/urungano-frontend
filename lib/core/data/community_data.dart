import '../models/community.dart';

// ── Circles ───────────────────────────────────────────────────────────────────

const List<Circle> kCircles = [
  Circle(
    id: 'circle_cycle_talk',
    slug: 'cycle_talk',
    name: 'Cycle talk',
    topic: 'Menstrual health',
    onlineCount: 34,
    messageCount: 127,
    emoji: '🌸',
    color: '#E85D75',    // rose
    bgColor: '#FCE4E8',  // rose-soft
    moderator: 'Nurse Aline',
  ),
  Circle(
    id: 'circle_hiv_testing',
    slug: 'hiv_testing',
    name: 'HIV & testing',
    topic: 'HIV prevention',
    onlineCount: 21,
    messageCount: 84,
    emoji: '💊',
    color: '#7FA99B',    // sage
    bgColor: '#D4E3DC',  // sage-soft
    moderator: 'Dr. Emmanuel',
  ),
  Circle(
    id: 'circle_know_your_body',
    slug: 'know_your_body',
    name: 'Know your body',
    topic: 'Reproductive anatomy',
    onlineCount: 18,
    messageCount: 63,
    emoji: '💡',
    color: '#E8A87C',    // amber
    bgColor: '#FAE0C8',  // peach-soft
    moderator: 'Nurse Aline',
  ),
  Circle(
    id: 'circle_relationships',
    slug: 'relationships',
    name: 'Relationships',
    topic: 'Healthy relationships',
    onlineCount: 54,
    messageCount: 209,
    emoji: '💬',
    color: '#4A2F37',    // plum-2
    bgColor: '#F8EADA',  // cream-2
    moderator: 'Counsellor Marie',
  ),
];

// ── Debates ───────────────────────────────────────────────────────────────────

const List<Debate> kDebates = [
  Debate(
    id: 'debate_1',
    question: 'Is it normal to skip periods sometimes?',
    yesPercent: 73,
    noPercent: 27,
    totalVotes: 412,
    tag: 'Menstrual health',
    heatColor: '#E85D75',
  ),
  Debate(
    id: 'debate_2',
    question: 'Can HIV be transmitted through saliva?',
    yesPercent: 22,
    noPercent: 78,
    totalVotes: 289,
    tag: 'HIV prevention',
    heatColor: '#7FA99B',
  ),
  Debate(
    id: 'debate_3',
    question: 'Should sex ed be taught in secondary school?',
    yesPercent: 88,
    noPercent: 12,
    totalVotes: 631,
    tag: 'Education',
    heatColor: '#F4B860',
  ),
];

// ── Anonymous questions ───────────────────────────────────────────────────────

final List<AnonQuestion> kAnonQuestions = [
  AnonQuestion(
    id: 'q1',
    text: 'I\'ve been having very painful cramps — is this endometriosis?',
    answered: true,
    reply:
        'Painful periods can have many causes. Endometriosis is one, but dysmenorrhea (primary painful periods) is more common. Please see a healthcare provider to rule out conditions. In the meantime, ibuprofen and heat pads can help manage pain.',
    answeredBy: 'Nurse Aline',
    createdAt: DateTime(2025, 4, 27, 10, 0),
  ),
  AnonQuestion(
    id: 'q2',
    text: 'Can you get pregnant the first time you have sex?',
    answered: true,
    reply:
        'Yes, absolutely. Pregnancy can occur any time unprotected sex happens, including the first time. There is no "safe" first time without contraception.',
    answeredBy: 'Dr. Emmanuel',
    createdAt: DateTime(2025, 4, 27, 7, 0),
  ),
  AnonQuestion(
    id: 'q3',
    text: 'How do I know if I need to get tested for STIs?',
    answered: false,
    createdAt: DateTime(2025, 4, 26, 12, 0),
  ),
];

// ── Chat messages per circle ──────────────────────────────────────────────────

final Map<String, List<ChatMessage>> kCircleMessages = {
  'cycle_talk': [
    ChatMessage(
      id: 'ct_1',
      who: 'Nurse Aline',
      avatarSeed: 'nurse_aline',
      isYou: false,
      isEducator: true,
      text:
          'Welcome everyone! This is a safe space to ask questions about your menstrual cycle. No question is too small.',
      createdAt: DateTime(2025, 4, 27, 10, 2),
    ),
    ChatMessage(
      id: 'ct_2',
      who: 'Amina',
      avatarSeed: 'amina',
      isYou: false,
      isEducator: false,
      text: 'Is spotting between periods something to worry about?',
      createdAt: DateTime(2025, 4, 27, 10, 14),
    ),
    ChatMessage(
      id: 'ct_3',
      who: 'Nurse Aline',
      avatarSeed: 'nurse_aline',
      isYou: false,
      isEducator: true,
      text:
          'Occasional spotting can be normal, especially around ovulation. But if it happens often or is heavy, it\'s worth seeing a provider.',
      createdAt: DateTime(2025, 4, 27, 10, 17),
    ),
    ChatMessage(
      id: 'ct_4',
      who: 'You',
      avatarSeed: 'you',
      isYou: true,
      isEducator: false,
      text: 'Does stress actually affect your period timing?',
      createdAt: DateTime(2025, 4, 27, 10, 21),
    ),
    ChatMessage(
      id: 'ct_5',
      who: 'Nurse Aline',
      avatarSeed: 'nurse_aline',
      isYou: false,
      isEducator: true,
      text:
          'Yes! Stress activates the HPA axis which can suppress GnRH, the hormone that triggers ovulation. High stress can delay or skip your period.',
      createdAt: DateTime(2025, 4, 27, 10, 23),
    ),
  ],
  'hiv_testing': [
    ChatMessage(
      id: 'ht_1',
      who: 'Dr. Emmanuel',
      avatarSeed: 'dr_emmanuel',
      isYou: false,
      isEducator: true,
      text:
          'Free HIV testing is available at all health centres in Rwanda every weekday. Results are confidential.',
      createdAt: DateTime(2025, 4, 27, 9, 30),
    ),
    ChatMessage(
      id: 'ht_2',
      who: 'Kalisa',
      avatarSeed: 'kalisa',
      isYou: false,
      isEducator: false,
      text: 'Do you need a referral letter to get tested?',
      createdAt: DateTime(2025, 4, 27, 9, 45),
    ),
    ChatMessage(
      id: 'ht_3',
      who: 'Dr. Emmanuel',
      avatarSeed: 'dr_emmanuel',
      isYou: false,
      isEducator: true,
      text:
          'No referral needed — you can walk in to any community health post or health centre and request a test.',
      createdAt: DateTime(2025, 4, 27, 9, 47),
    ),
    ChatMessage(
      id: 'ht_4',
      who: 'You',
      avatarSeed: 'you',
      isYou: true,
      isEducator: false,
      text: 'How long after exposure should you wait before testing?',
      createdAt: DateTime(2025, 4, 27, 10, 5),
    ),
  ],
  'know_your_body': [
    ChatMessage(
      id: 'kyb_1',
      who: 'Nurse Aline',
      avatarSeed: 'nurse_aline',
      isYou: false,
      isEducator: true,
      text:
          'Today we\'re exploring reproductive anatomy. Feel free to use the 3D lesson alongside our chat!',
      createdAt: DateTime(2025, 4, 27, 11, 0),
    ),
    ChatMessage(
      id: 'kyb_2',
      who: 'Clarisse',
      avatarSeed: 'clarisse',
      isYou: false,
      isEducator: false,
      text: 'What does the cervix actually do?',
      createdAt: DateTime(2025, 4, 27, 11, 8),
    ),
    ChatMessage(
      id: 'kyb_3',
      who: 'Nurse Aline',
      avatarSeed: 'nurse_aline',
      isYou: false,
      isEducator: true,
      text:
          'The cervix is the lower part of the uterus that opens into the vagina. It produces mucus that changes throughout your cycle, and dilates during childbirth.',
      createdAt: DateTime(2025, 4, 27, 11, 10),
    ),
  ],
  'relationships': [
    ChatMessage(
      id: 'rel_1',
      who: 'Counsellor Marie',
      avatarSeed: 'counsellor_marie',
      isYou: false,
      isEducator: true,
      text:
          'Healthy relationships are built on mutual respect, open communication, and shared boundaries. What topics would you like to explore today?',
      createdAt: DateTime(2025, 4, 27, 8, 0),
    ),
    ChatMessage(
      id: 'rel_2',
      who: 'Fidele',
      avatarSeed: 'fidele',
      isYou: false,
      isEducator: false,
      text: 'How do you set boundaries when your partner doesn\'t respect them?',
      createdAt: DateTime(2025, 4, 27, 8, 22),
    ),
    ChatMessage(
      id: 'rel_3',
      who: 'Counsellor Marie',
      avatarSeed: 'counsellor_marie',
      isYou: false,
      isEducator: true,
      text:
          'Start by clearly naming the boundary and the consequence if it\'s crossed. If a partner consistently ignores your limits, that is a serious red flag worth discussing with a trusted adult or counsellor.',
      createdAt: DateTime(2025, 4, 27, 8, 25),
    ),
    ChatMessage(
      id: 'rel_4',
      who: 'You',
      avatarSeed: 'you',
      isYou: true,
      isEducator: false,
      text: 'How do you tell if a relationship is healthy or not?',
      createdAt: DateTime(2025, 4, 27, 8, 31),
    ),
  ],
};
