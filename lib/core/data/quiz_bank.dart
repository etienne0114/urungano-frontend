import '../models/quiz_question.dart';

/// Offline quiz question bank — mirrors the backend `lesson.seed.ts` exactly.
/// Consumed by [QuizScreen]. Keys are lesson IDs.
const Map<String, List<QuizQuestion>> kQuizBank = {
  'your_cycle': [
    QuizQuestion(
      id: 'q1',
      lessonId: 'your_cycle',
      questionText: 'How often does ovulation usually happen?',
      localizedQuestionText: {
        'fr': "A quelle frequence l'ovulation se produit-elle habituellement ?",
        'rw': "Ni kangahe intanga ngore isanzwe irekurwa (ovulation)?",
      },
      options: [
        'Every day',
        'Once per menstrual cycle',
        'Twice per month',
        'Only during periods'
      ],
      localizedOptions: {
        'fr': [
          'Chaque jour',
          'Une fois par cycle menstruel',
          'Deux fois par mois',
          'Uniquement pendant les regles',
        ],
        'rw': [
          'Buri munsi',
          "Rimwe muri buri muzingo w'imihango",
          'Kabiri mu kwezi',
          'Gusa mu gihe cy\'imihango',
        ],
      },
      correctIndex: 1,
      explanation:
          'Ovulation happens once per cycle, typically around day 14 of a 28-day cycle.',
      localizedExplanation: {
        'fr':
            "L'ovulation a lieu une fois par cycle, souvent vers le 14e jour d'un cycle de 28 jours.",
        'rw':
            "Ovulation iba rimwe muri buri muzingo, akenshi hafi y'umunsi wa 14 mu muzingo w'iminsi 28.",
      },
    ),
    QuizQuestion(
      id: 'q2',
      lessonId: 'your_cycle',
      questionText: 'What causes period cramps?',
      localizedQuestionText: {
        'fr': 'Quelles sont les causes des crampes menstruelles ?',
        'rw': "Ni iki gitera ububabare bwo mu mihango?",
      },
      options: [
        'Drinking cold water',
        'Uterus contracting to shed lining',
        'Not exercising',
        'Eating spicy food'
      ],
      localizedOptions: {
        'fr': [
          "Boire de l'eau froide",
          "Les contractions de l'uterus pour evacuer la muqueuse",
          "Ne pas faire d'exercice",
          'Manger epice',
        ],
        'rw': [
          'Kunywa amazi akonje',
          "Kwikanya kwa nyababyeyi kugira ngo isohore umwenda wayo",
          'Kutakora imyitozo',
          'Kurya ibiryo birimo urusenda rwinshi',
        ],
      },
      correctIndex: 1,
      explanation:
          'Prostaglandins trigger uterine contractions that shed the endometrial lining.',
      localizedExplanation: {
        'fr':
            "Les prostaglandines declenchent des contractions uterines qui eliminent la muqueuse endometriale.",
        'rw':
            "Prostaglandines zitera kwikanya kwa nyababyeyi, bigatuma umwenda wa endometri usohoka.",
      },
    ),
    QuizQuestion(
      id: 'q3',
      lessonId: 'your_cycle',
      questionText: 'Which organ produces eggs?',
      localizedQuestionText: {
        'fr': 'Quel organe produit les ovules ?',
        'rw': 'Ni uruhe rugingo rutanga intanga ngore?',
      },
      options: ['Uterus', 'Cervix', 'Ovary', 'Fallopian tube'],
      localizedOptions: {
        'fr': ['Uterus', 'Col de l\'uterus', 'Ovaire', 'Trompe de Fallope'],
        'rw': [
          'Nyababyeyi',
          'Inkondo ya nyababyeyi',
          'Intangangore',
          'Umuyoboro wa fallope'
        ],
      },
      correctIndex: 2,
      explanation: 'The ovaries produce and release eggs during ovulation.',
      localizedExplanation: {
        'fr':
            "Les ovaires produisent puis liberent les ovules pendant l'ovulation.",
        'rw':
            'Intangangore ni zo zitanga kandi zikarekura intanga ngore mu gihe cya ovulation.',
      },
    ),
    QuizQuestion(
      id: 'q4',
      lessonId: 'your_cycle',
      questionText: 'How many phases does the menstrual cycle have?',
      localizedQuestionText: {
        'fr': 'Combien de phases comporte le cycle menstruel ?',
        'rw': "Umuzingo w'imihango ugira ibyiciro bingahe?",
      },
      options: ['2', '3', '4', '5'],
      correctIndex: 2,
      explanation:
          'The four phases are: menstruation, follicular, ovulation, and luteal.',
      localizedExplanation: {
        'fr':
            'Les quatre phases sont : menstruelle, folliculaire, ovulation et luteale.',
        'rw':
            "Ibyiciro bine ni ibi: imihango, ikura rya follicule, ovulation, n'icyiciro luteale.",
      },
    ),
    QuizQuestion(
      id: 'q5',
      lessonId: 'your_cycle',
      questionText: 'What is the endometrium?',
      localizedQuestionText: {
        'fr': "Qu'est-ce que l'endometre ?",
        'rw': 'Endometri ni iki?',
      },
      options: [
        'Outer layer of the ovary',
        'Lining of the uterus',
        'A type of hormone',
        'The cervical canal'
      ],
      localizedOptions: {
        'fr': [
          "La couche externe de l'ovaire",
          "La muqueuse de l'uterus",
          "Un type d'hormone",
          'Le canal cervical',
        ],
        'rw': [
          'Igice cyo hanze cy\'intangangore',
          'Umwenda wo muri nyababyeyi',
          "Ubwoko bw'imisemburo",
          'Umuyoboro wo mu nkondo ya nyababyeyi',
        ],
      },
      correctIndex: 1,
      explanation:
          'The endometrium is the inner lining of the uterus that sheds during menstruation.',
      localizedExplanation: {
        'fr':
            "L'endometre est la muqueuse interne de l'uterus qui se detache pendant les regles.",
        'rw':
            "Endometri ni umwenda wo imbere muri nyababyeyi usohoka mu gihe cy'imihango.",
      },
    ),
  ],
  'hiv_prevention': [
    QuizQuestion(
      id: 'q1',
      lessonId: 'hiv_prevention',
      questionText: 'What does HIV stand for?',
      localizedQuestionText: {
        'fr': 'Que signifie VIH ?',
        'rw': 'VIH bisobanura iki?',
      },
      options: [
        'Human Immunodeficiency Virus',
        'High Infection Viral',
        'Health Impact Virus',
        'Human Intestinal Virus'
      ],
      localizedOptions: {
        'fr': [
          "Virus de l'Immunodeficience Humaine",
          'Virus de forte infection',
          "Virus d'impact sur la sante",
          'Virus intestinal humain',
        ],
        'rw': [
          'Virusi yangiza ubudahangarwa bw\'umubiri',
          'Virusi y\'ubwandu bukabije',
          'Virusi igira ingaruka ku buzima',
          "Virusi yo mu mara y'umuntu",
        ],
      },
      correctIndex: 0,
      explanation: 'HIV = Human Immunodeficiency Virus.',
      localizedExplanation: {
        'fr': "VIH = Virus de l'Immunodeficience Humaine.",
        'rw': "VIH = Virusi itera kugabanuka k'ubudahangarwa bw'umubiri.",
      },
    ),
    QuizQuestion(
      id: 'q2',
      lessonId: 'hiv_prevention',
      questionText: 'HIV can be spread by:',
      localizedQuestionText: {
        'fr': 'Le VIH peut se transmettre par :',
        'rw': 'VIH ishobora kwandura binyuze muri:',
      },
      options: ['Sharing food', 'Mosquito bites', 'Hugging', 'Unprotected sex'],
      localizedOptions: {
        'fr': [
          'Le partage de nourriture',
          'Les piqures de moustiques',
          "Le fait de s'etreindre",
          'Les rapports sexuels non proteges',
        ],
        'rw': [
          'Gusangira ibiryo',
          "Kurumwa n'imibu",
          'Guhoberana',
          'Imibonano mpuzabitsina idakingiye',
        ],
      },
      correctIndex: 3,
      explanation: 'HIV spreads through bodily fluids, not casual contact.',
      localizedExplanation: {
        'fr':
            'Le VIH se transmet par certains liquides corporels, pas par contact ordinaire.',
        'rw':
            "VIH yandurira mu matembabuzi y'umubiri, ntabwo yandurira mu biganiro bisanzwe.",
      },
    ),
    QuizQuestion(
      id: 'q3',
      lessonId: 'hiv_prevention',
      questionText: 'Which medication prevents HIV in HIV-negative people?',
      localizedQuestionText: {
        'fr':
            'Quel medicament previent le VIH chez les personnes seronegatives ?',
        'rw': 'Ni uwuhe muti urinda VIH ku bantu badafite VIH?',
      },
      options: ['Aspirin', 'PrEP', 'Antihistamine', 'Paracetamol'],
      correctIndex: 1,
      explanation: 'PrEP (Pre-Exposure Prophylaxis) prevents HIV infection.',
      localizedExplanation: {
        'fr':
            "La PrEP (prophylaxie pre-exposition) previent l'infection par le VIH.",
        'rw':
            "PrEP (umuti wo kwirinda mbere yo guhura n'ibyago) ifasha kwirinda kwandura VIH.",
      },
    ),
    QuizQuestion(
      id: 'q4',
      lessonId: 'hiv_prevention',
      questionText: 'Which cells does HIV primarily attack?',
      localizedQuestionText: {
        'fr': 'Quelles cellules le VIH attaque-t-il en priorite ?',
        'rw': 'VIH yibasira cyane utuhe turemangingo?',
      },
      options: [
        'Red blood cells',
        'Platelets',
        'CD4 T-cells',
        'Bone marrow cells'
      ],
      localizedOptions: {
        'fr': [
          'Globules rouges',
          'Plaquettes',
          'Cellules T CD4',
          'Cellules de la moelle osseuse',
        ],
        'rw': [
          'Uturemangingo dutukura two mu maraso',
          'Plaquettes',
          'Uturemangingo twa CD4 T',
          "Uturemangingo two mu mwonko w'amagufa",
        ],
      },
      correctIndex: 2,
      explanation: 'HIV targets CD4 T-cells, essential for immune function.',
      localizedExplanation: {
        'fr':
            "Le VIH cible les cellules T CD4, essentielles au systeme immunitaire.",
        'rw':
            'VIH yibasira uturemangingo twa CD4 T dufasha ubudahangarwa bw\'umubiri.',
      },
    ),
  ],
  'anatomy_101': [
    QuizQuestion(
      id: 'q1',
      lessonId: 'anatomy_101',
      questionText: 'Where does fertilisation usually occur?',
      localizedQuestionText: {
        'fr': 'Ou la fecondation se produit-elle habituellement ?',
        'rw': 'Gusama gukunda kubera he?',
      },
      options: [
        'In the uterus',
        'In the fallopian tube',
        'In the ovary',
        'In the cervix'
      ],
      localizedOptions: {
        'fr': [
          "Dans l'uterus",
          'Dans la trompe de Fallope',
          "Dans l'ovaire",
          'Dans le col de l\'uterus'
        ],
        'rw': [
          'Muri nyababyeyi',
          'Mu muyoboro wa fallope',
          "Mu ntangangore",
          'Mu nkondo ya nyababyeyi'
        ],
      },
      correctIndex: 1,
      explanation: 'Fertilisation usually takes place in the fallopian tube.',
      localizedExplanation: {
        'fr':
            'La fecondation a lieu le plus souvent dans la trompe de Fallope.',
        'rw': 'Akenshi gusama bibera mu muyoboro wa fallope.',
      },
    ),
    QuizQuestion(
      id: 'q2',
      lessonId: 'anatomy_101',
      questionText: 'Which hormone is produced by the testes?',
      localizedQuestionText: {
        'fr': 'Quelle hormone est produite par les testicules ?',
        'rw': 'Ni uwuhe musemburo ukorwa n\'udusabo tw\'intanga?',
      },
      options: ['Oestrogen', 'Progesterone', 'Testosterone', 'Oxytocin'],
      correctIndex: 2,
      explanation:
          'The testes produce testosterone, the main male sex hormone.',
      localizedExplanation: {
        'fr':
            'Les testicules produisent la testosterone, principale hormone sexuelle masculine.',
        'rw':
            "Udusabo tw'intanga dukora testosterone, ari wo musemburo nyamukuru w'igitsina gabo.",
      },
    ),
  ],
};
