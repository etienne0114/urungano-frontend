import '../models/lesson.dart';

// Base URL for 3D model assets. In production, update to the deployed API URL.
const _modelBase = 'http://localhost:4000/static/models';

/// Full lesson content   chapters, narration (EN/FR/RW), hotspots.
///
/// Used as an OFFLINE FALLBACK when the API cannot be reached.
/// The backend seeds identical content so API and bundled data are in sync.
const Map<String, Lesson> kLessonContent = {
  // ─────────────────────────────────────────────────────────────────────────
  // Lesson 1   Your cycle, explained (Menstrual Health)
  // ─────────────────────────────────────────────────────────────────────────
  'your_cycle': Lesson(
    id: 'your_cycle',
    title: 'Your cycle, explained',
    localizedTitle: {
      'en': 'Your cycle, explained',
      'fr': 'Votre cycle, expliqué',
      'rw': 'Incurane yawe, isobanurwa',
    },
    category: LessonCategory.menstrualHealth,
    durationMinutes: 8,
    chapters: [
      LessonChapter(
        id: 'your_cycle_c0',
        orderIndex: 0,
        title: 'What is menstruation?',
        localizedTitle: {
          'en': 'What is menstruation?',
          'fr': "Qu'est-ce que la menstruation ?",
          'rw': 'Imihango ni iki?',
        },
        narrationText:
            'The menstrual cycle is a monthly biological process. A cycle lasts 21 to 35 days on average. Hormones control every phase. The lining of the uterus (the endometrium) builds up and sheds if no pregnancy occurs.',
        localizedNarration: {
          'en':
              'The menstrual cycle is a monthly biological process in bodies with a uterus. It prepares the body for a possible pregnancy. A cycle usually lasts 21 to 35 days, with an average of 28 days. The uterus lining (the endometrium) builds up and then sheds if no pregnancy occurs. This shedding is your period. Bleeding typically lasts 3 to 7 days. Hormones (including oestrogen, progesterone, LH, and FSH) control every phase of the cycle.',
          'fr':
              "Le cycle menstruel est un processus biologique mensuel dans les corps possédant un utérus. Il prépare le corps à une éventuelle grossesse. Un cycle dure généralement de 21 à 35 jours, avec une moyenne de 28 jours. La muqueuse utérine (l'endomètre) s'épaissit puis se déverse si aucune grossesse ne survient. Cette desquamation est vos règles. Les saignements durent généralement 3 à 7 jours.",
          'rw':
              "Incurane ni imikorere ya buri kwezi. Itegura umubiri kwakira inda. Imara iminsi 21-35. Umwenda wa nyababyeyi urasohoka niba nta nda. Imisemburo igenzura byose.",
        },
        modelUrl: '$_modelBase/uterus.glb',
        hotspots: [],
      ),
      LessonChapter(
        id: 'your_cycle_c1',
        orderIndex: 1,
        title: 'The uterus and ovaries',
        localizedTitle: {
          'en': 'The uterus and ovaries',
          'fr': "L'utérus et les ovaires",
          'rw': 'Nyababyeyi n’intangangore',
        },
        narrationText:
            'The uterus is a pear-shaped muscular organ. Two ovaries produce eggs and hormones. Fallopian tubes connect the ovaries to the uterus. During ovulation, one egg is released.',
        localizedNarration: {
          'en':
              'The uterus is a pear-shaped muscular organ about the size of your fist. Two ovaries   each about the size of an almond   produce eggs and hormones. Fallopian tubes connect the ovaries to the uterus. During ovulation, one ovary releases a single egg. If sperm fertilises the egg, it implants in the uterine lining and grows into a baby.',
          'fr':
              "L'utérus est un organe musculaire en forme de poire, de la taille d'un poing environ. Deux ovaires   chacun de la taille d'une amande   produisent des ovules et des hormones. Les trompes de Fallope relient les ovaires à l'utérus. Lors de l'ovulation, un ovaire libère un seul ovule.",
          'rw':
              "Nyababyeyi ni urugingo rw'imikaya. Intangangore ebyiri zitanga intanga n'imisemburo. Imiyoboro ihuza intangangore na nyababyeyi. Mu ovulation, intanga irekurwa. Niba ihuye n'intanga ngabo, ishobora gusama.",
        },
        modelUrl: '$_modelBase/uterus.glb',
        hotspots: [
          Hotspot(
            id: 'hs_ovary_left',
            number: 1,
            title: 'Left ovary',
            description:
                'Each ovary contains hundreds of thousands of egg follicles. Monthly, hormones stimulate several to grow; usually one releases a mature egg at ovulation.',
          ),
          Hotspot(
            id: 'hs_fallopian',
            number: 2,
            title: 'Fallopian tube',
            description:
                'About 10 cm long. Transports the egg from ovary to uterus. Fertilisation by sperm most often occurs in the outer third of the tube.',
          ),
          Hotspot(
            id: 'hs_lining',
            number: 3,
            title: 'Uterine lining',
            description:
                'The endometrium thickens each cycle under oestrogen and progesterone. If no egg implants, progesterone drops and the lining sheds as a period.',
          ),
          Hotspot(
            id: 'hs_cervix',
            number: 4,
            title: 'Cervix',
            description:
                'Lower, narrow portion of the uterus. Produces mucus that changes texture throughout the cycle   clear and stretchy at ovulation, thick at other times.',
          ),
        ],
      ),
      LessonChapter(
        id: 'your_cycle_c2',
        orderIndex: 2,
        title: 'The 4 phases',
        localizedTitle: {
          'en': 'The 4 phases',
          'fr': 'Les 4 phases',
          'rw': 'Ibyiciro 4 by’incurane',
        },
        narrationText:
            'Phase 1: Menstruation (days 1-5). Phase 2: Follicular (FSH stimulates follicle growth). Phase 3: Ovulation (LH surge, egg released). Phase 4: Luteal (progesterone rises).',
        localizedNarration: {
          'en':
              'Phase one: Menstruation (days one to five). The endometrium sheds and hormone levels are at their lowest. Phase two: Follicular (FSH stimulates follicles to grow and produce oestrogen). Phase three: Ovulation (around day fourteen). A surge of LH triggers release of a mature egg. This is the most fertile time. Phase four: Luteal (days fifteen to twenty-eight). The empty follicle produces progesterone. If no fertilisation occurs, progesterone falls and menstruation begins again.',
          'fr':
              "Phase un : Menstruation (jours 1 à 5). L'endomètre se détache. Phase deux : Folliculaire (FSH stimule la croissance des follicules). Phase trois : Ovulation (vers le 14e jour, la LH déclenche la libération d'un ovule mature). Phase quatre : Lutéale (le follicule vide produit de la progestérone). Sans fécondation, les règles recommencent.",
          'rw':
              "Icyiciro 1: Imihango (iminsi 1-5). Umwenda usohoka. Icyiciro 2: Follicule. FSH itera gukura. Icyiciro 3: Ovulation (umunsi 14). Intanga irekurwa. Icyiciro 4: Luteale (iminsi 15-28). Progesterone iragabanyuka.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'your_cycle_c3',
        orderIndex: 3,
        title: 'Cramps & pain management',
        localizedTitle: {
          'en': 'Cramps & pain management',
          'fr': 'Crampes et gestion de la douleur',
          'rw': 'Ububabare n’uburyo bwo kubugabanya',
        },
        narrationText:
            'Period cramps are caused by prostaglandins. Effective relief: heat therapy, ibuprofen before pain peaks, gentle exercise, and staying hydrated.',
        localizedNarration: {
          'en':
              'Period cramps (dysmenorrhea) are caused by prostaglandins, chemicals that trigger uterine muscle contractions. Effective relief includes: applying heat to the lower abdomen for 15-20 minutes, taking ibuprofen or naproxen before pain peaks, gentle exercise like walking or yoga, and staying hydrated. If cramps are severe enough to disrupt daily life or do not respond to these measures, see a health worker.',
          'fr':
              "Les crampes   dysménorrhée   sont causées par des prostaglandines. Les options de soulagement efficaces comprennent l'application de chaleur sur le bas-ventre, la prise d'ibuprofène avant le pic de douleur, une activité physique douce et une bonne hydratation.",
          'rw':
              "Ububabare buterwa na prostaglandins. Uburyo bwo kubugabanya: shyira ubushyuhe ku nda, fata ibuprofen, ukore siporo yoroshye, unywe amazi.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'your_cycle_c4',
        orderIndex: 4,
        title: 'Tracking your cycle',
        localizedTitle: {
          'en': 'Tracking your cycle',
          'fr': 'Suivre votre cycle',
          'rw': 'Gukurikirana ukwezi kwawe',
        },
        narrationText:
            'Tracking helps predict your next period. Record first day, duration, and symptoms. Patterns emerge over 3 to 6 months. Normal cycles are 21 to 35 days.',
        localizedNarration: {
          'en':
              'Tracking your cycle helps you understand your body and predict when your next period will come. Use a calendar, notebook, or app. Record the first day of each period, how long it lasts, and any symptoms. Over three to six months, patterns emerge showing your typical cycle length and fertile window. Normal cycles range from 21 to 35 days.',
          'fr':
              "Suivre votre cycle vous aide à comprendre votre corps et à prévoir vos prochaines règles. Notez le premier jour, la durée et les symptômes. Au bout de trois à six mois, des schémas apparaissent. Les cycles normaux durent 21 à 35 jours.",
          'rw':
              "Gukurikirana ukwezi bigufasha kumenya umubiri wawe. Andika umunsi wa mbere, iminsi imara, n'ibimenyetso. Mu mezi 3-6, uzabona imiterere. Ukwezi gusanzwe kumara iminsi 21-35.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'your_cycle_c5',
        orderIndex: 5,
        title: 'Common myths',
        localizedTitle: {
          'en': 'Common myths',
          'fr': 'Mythes courants',
          'rw': 'Imyumvire itari yo ikunze kubaho',
        },
        narrationText:
            'Myth: no exercise during period. Fact: exercise reduces cramp pain. Myth: period blood is dirty. Fact: menstrual fluid is a normal mix of blood and endometrial tissue.',
        localizedNarration: {
          'en':
              'Myth: You cannot swim or exercise during your period. Fact: Exercise increases blood flow and can reduce cramp pain. Swimming is safe. Myth: Period blood is dirty. Fact: Menstrual fluid is a normal mix of blood, endometrial tissue, and mucus. Myth: You cannot get pregnant during your period. Fact: Sperm can survive up to 5 days. Pregnancy is possible if ovulation follows soon after bleeding.',
          'fr':
              "Mythe : On ne peut pas nager ni faire d'exercice pendant ses règles. Réalité : l'exercice peut réduire les crampes en augmentant le flux sanguin. La natation est sans danger. Mythe : Le sang des règles est sale ou impur. Réalité : le flux menstruel est un mélange normal de sang, de tissu endométrial et de mucus. Mythe : On ne peut pas tomber enceinte pendant ses règles. Réalité : les spermatozoïdes peuvent survivre jusqu'à 5 jours.",
          'rw':
              "Imyumvire itari yo: Ntubarwa koga mu mihango. Ukuri: Siporo igabanya ububabare. Imyumvire itari yo: Amaraso y'imihango ni amahambwe. Ukuri: Ni integanyo isanzwe.",
        },
        hotspots: [],
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Lesson 2   How HIV Works & Prevention (HIV & STI)
  // ─────────────────────────────────────────────────────────────────────────
  'hiv_prevention': Lesson(
    id: 'hiv_prevention',
    title: 'How HIV works & prevention',
    localizedTitle: {
      'en': 'How HIV works & prevention',
      'fr': 'Comment fonctionne le VIH et la prévention',
      'rw': "Uko VIH ikora n'uburyo bwo kwirinda",
    },
    category: LessonCategory.hivSti,
    durationMinutes: 12,
    chapters: [
      LessonChapter(
        id: 'hiv_c0',
        orderIndex: 0,
        title: 'What is HIV?',
        localizedTitle: {
          'en': 'What is HIV?',
          'fr': "Qu'est-ce que le VIH ?",
          'rw': 'VIH ni iki?',
        },
        narrationText:
            'HIV (Human Immunodeficiency Virus) attacks CD4 T-cells   white blood cells that lead the immune system. Modern ART keeps viral load undetectable. People on ART live long, healthy lives.',
        localizedNarration: {
          'en':
              'HIV stands for Human Immunodeficiency Virus. It attacks the immune system, specifically CD4 T-cells. Without treatment, HIV slowly destroys these cells, eventually leading to AIDS. Modern antiretroviral therapy   ART   reduces HIV in the blood to an undetectable level. People on effective ART live long, healthy lives and cannot transmit the virus sexually.',
          'fr':
              "Le VIH signifie Virus de l'Immunodéficience Humaine. Il attaque le système immunitaire, en particulier les cellules CD4. Sans traitement, il conduit à terme au SIDA. Le traitement antirétroviral moderne   ARV   réduit le VIH à un niveau indétectable. Les personnes sous ARV efficace vivent longtemps en bonne santé.",
          'rw':
              "VIH ni virusi yangiza ubudahangarwa bw'umubiri. Yibasira uturemangingo twa CD4. Iyo itavuwe, ishobora kugera ku SIDA. Imiti ya ART igabanya virusi mu maraso. Abafata ART neza bashobora kubaho ubuzima burebure.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'hiv_c1',
        orderIndex: 1,
        title: 'How HIV spreads',
        localizedTitle: {
          'en': 'How HIV spreads',
          'fr': 'Comment le VIH se transmet',
          'rw': 'Uko VIH yandura',
        },
        narrationText:
            'HIV spreads through: blood, semen, vaginal fluids, breast milk. NOT through saliva, sweat, sharing food, hugging, or insect bites.',
        localizedNarration: {
          'en':
              'HIV is only transmitted through specific body fluids: blood, semen, vaginal and rectal fluids, and breast milk. The most common routes are unprotected sexual intercourse, sharing needles, and mother-to-child transmission. HIV is NOT transmitted through saliva, tears, sweat, urine, or by sharing food, hugging, handshaking, or insect bites.',
          'fr':
              "Le VIH ne se transmet que par des fluides corporels spécifiques : sang, sperme, sécrétions vaginales et lait maternel. Les voies les plus courantes sont les rapports sexuels non protégés, le partage de seringues et la transmission mère-enfant. Le VIH ne se transmet PAS par la salive, la sueur, le partage de nourriture ou les piqûres d'insectes.",
          'rw':
              "VIH yandurira mu matembabuzi y'umubiri: amaraso, amasohoro, amatembabuzi yo mu myanya ndangagitsina, n'amata yonsa. Ikunze kwandurira mu mibonano idakingiye, gusangira inshinge, cyangwa kuva ku mubyeyi ujya ku mwana. Ntiyandurira mu macandwe, ibyuya, kurya hamwe, cyangwa kurumwa n'udukoko.",
        },
        modelUrl: '$_modelBase/cd4-cell.glb',
        hotspots: [
          Hotspot(
            id: 'hs_blood',
            number: 1,
            title: 'Blood transmission',
            description:
                'Sharing needles or syringes introduces HIV directly into the bloodstream. Blood has high HIV concentrations, making this a high-risk route.',
          ),
          Hotspot(
            id: 'hs_sexual',
            number: 2,
            title: 'Sexual transmission',
            description:
                'Unprotected sex is the most common HIV route. Condoms used correctly every time reduce risk by over 98%. Anal sex carries higher risk than vaginal sex.',
          ),
          Hotspot(
            id: 'hs_mtct',
            number: 3,
            title: 'Mother-to-child',
            description:
                "HIV can pass during pregnancy, birth, or breastfeeding. With ART started early, risk falls below 1%. Rwanda's PMTCT programme has achieved near-zero transmission.",
          ),
        ],
      ),
      LessonChapter(
        id: 'hiv_c2',
        orderIndex: 2,
        title: 'Prevention methods',
        localizedTitle: {
          'en': 'Prevention methods',
          'fr': 'Méthodes de prévention',
          'rw': 'Uburyo bwo kwirinda',
        },
        narrationText:
            'Condoms every time (98% effective). PrEP daily pill (99% effective for HIV-negative people). Regular testing. Avoid sharing needles. All free in Rwanda.',
        localizedNarration: {
          'en':
              'Effective prevention strategies: Use condoms correctly every time   over 98% effective. Know your status through regular HIV testing. If at substantial risk, ask about PrEP   a daily pill that prevents HIV by over 99%. If recently exposed, seek PEP within 72 hours. Avoid sharing needles. All these services are free at Rwanda public health centres.',
          'fr':
              "Stratégies de prévention efficaces : utiliser des préservatifs correctement à chaque fois (plus de 98% d'efficacité). Connaître son statut par des tests réguliers. Si à haut risque, se renseigner sur le PrEP (pilule quotidienne, plus de 99% d'efficacité). En cas d'exposition récente, demander le PEP dans les 72 heures.",
          'rw':
              "Uburyo bwo kwirinda VIH: gukoresha agakingirizo neza buri gihe, kwipimisha kenshi, no gukoresha PrEP ku bantu bafite ibyago. Niba habayeho ibyago vuba, shakisha PEP mu masaha 72. Ntugasangire inshinge n'abandi.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'hiv_c3',
        orderIndex: 3,
        title: 'ART & living with HIV',
        localizedTitle: {
          'en': 'ART & living with HIV',
          'fr': 'ARV et vie avec le VIH',
          'rw': 'ART no kubana na VIH',
        },
        narrationText:
            'ART makes viral load undetectable. Undetectable = Untransmittable (U=U). Free ART is available at all Rwanda health centres.',
        localizedNarration: {
          'en':
              'Antiretroviral therapy   ART   stops HIV from reproducing. Taken daily, ART reduces viral load to undetectable levels. An undetectable viral load means HIV cannot be sexually transmitted   known as U=U: Undetectable equals Untransmittable. In Rwanda, ART is free for all people living with HIV and available at all health centres.',
          'fr':
              "Le traitement antirétroviral   ARV   empêche le VIH de se reproduire. Pris quotidiennement, il rend la charge virale indétectable. Une charge virale indétectable signifie que le VIH ne peut pas se transmettre sexuellement   principe I=I. Au Rwanda, les ARV sont gratuits dans tous les centres de santé.",
          'rw':
              "ART ni imiti ihagarika kwiyongera kwa VIH. Iyo ifashwe buri munsi neza, virusi ishobora kugera ku rwego rudasanzwe ruboneka. Ibyo bisobanura ko idashobora kwanduza (U=U). Mu Rwanda, ART itangirwa ubuntu.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'hiv_c4',
        orderIndex: 4,
        title: 'Testing & reducing stigma',
        localizedTitle: {
          'en': 'Testing & reducing stigma',
          'fr': 'Dépistage et réduction de la stigmatisation',
          'rw': 'Kwipimisha no kugabanya ivangura',
        },
        narrationText:
            'HIV testing is free and confidential in Rwanda. Community testing reaches schools and markets. HIV stigma is based on misinformation   HIV is a manageable condition.',
        localizedNarration: {
          'en':
              'HIV testing is the only way to know your status. In Rwanda, testing is free, confidential, and available at all health centres for everyone. Community testing vans reach schools, markets, and workplaces. HIV-related stigma is based on misinformation. HIV is a manageable medical condition, not a moral failing. Knowing your status empowers you to protect yourself and others.',
          'fr':
              "Le dépistage du VIH est le seul moyen de connaître son statut. Au Rwanda, il est gratuit et confidentiel dans tous les centres de santé. La stigmatisation liée au VIH est basée sur des informations erronées   le VIH est une maladie gérable, pas un échec moral.",
          'rw':
              "Kwipimisha ni bwo buryo bwonyine bwo kumenya niba ufite VIH. Mu Rwanda, serivisi yo kwipimisha ni ubuntu kandi ikorwa mu ibanga. Ivangura rikomoka ku makuru atari yo. VIH ni indwara ivurwa kandi igenzurwa.",
        },
        hotspots: [],
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Lesson 3   Reproductive Anatomy 101 (Anatomy)
  // ─────────────────────────────────────────────────────────────────────────
  'anatomy_101': Lesson(
    id: 'anatomy_101',
    title: 'Reproductive anatomy 101',
    localizedTitle: {
      'en': 'Reproductive anatomy 101',
      'fr': 'Anatomie reproductive 101',
      'rw': 'Imiterere y’imyanya myibarukiro 101',
    },
    category: LessonCategory.anatomy,
    durationMinutes: 10,
    chapters: [
      LessonChapter(
        id: 'anatomy_c0',
        orderIndex: 0,
        title: 'Introduction',
        localizedTitle: {
          'en': 'Introduction',
          'fr': 'Introduction',
          'rw': 'Intangiriro',
        },
        narrationText:
            'Reproductive anatomy refers to the organs involved in sexual reproduction. Understanding anatomy supports healthcare decisions and sexual health literacy.',
        localizedNarration: {
          'en':
              'Reproductive anatomy refers to the organs involved in sexual reproduction. Understanding your own anatomy is fundamental to sexual health literacy. It helps you make informed decisions, recognise when something feels wrong, and communicate with healthcare providers. In this lesson we explore the female and male reproductive systems and how fertilisation occurs.',
          'fr':
              "L'anatomie reproductive désigne les organes impliqués dans la reproduction sexuelle. La comprendre est fondamental pour la littératie en santé sexuelle et aide à prendre des décisions éclairées et à communiquer avec les professionnels de santé.",
          'rw':
              "Imiterere y'imyanya myibarukiro ni ingingo z'umubiri zigira uruhare mu kororoka. Kuyisobanukirwa bigufasha gufata ibyemezo byiza, kumenya impinduka zidasanzwe, no kuganira neza n'abaganga.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'anatomy_c1',
        orderIndex: 1,
        title: 'Female reproductive system',
        localizedTitle: {
          'en': 'Female reproductive system',
          'fr': 'Système reproducteur féminin',
          'rw': "Imyanya myibarukiro y'umugore",
        },
        narrationText:
            'Ovaries produce eggs and hormones. Fallopian tubes transport eggs. Uterus is where a baby develops. Cervix connects uterus to vagina. External vulva includes labia, clitoris.',
        localizedNarration: {
          'en':
              'The female reproductive system includes the ovaries   which produce eggs and oestrogen and progesterone. The fallopian tubes transport eggs from the ovaries to the uterus. The uterus is where a baby develops during pregnancy. The cervix is the lower, narrow end of the uterus. The vagina is a muscular canal connecting the uterus to the outside. Externally, the vulva includes the labia, clitoris, and vaginal opening.',
          'fr':
              "Le système reproducteur féminin comprend les ovaires   qui produisent des ovules, des œstrogènes et de la progestérone. Les trompes de Fallope transportent les ovules vers l'utérus. L'utérus est l'endroit où un bébé se développe. Le col relie l'utérus au vagin. La vulve externe comprend les lèvres, le clitoris et l'ouverture vaginale.",
          'rw':
              "Imyanya myibarukiro y’umugore irimo intangangore zitanga intanga ngore n’imisemburo nka estrogene na progesiteroni. Imiyoboro y’intanga ngore itwara intanga ijya muri nyababyeyi. Nyababyeyi ni ho umwana akurira igihe cy’inda. Inkondo ya nyababyeyi ihuza nyababyeyi n’igituba. Hanze hari igice cyitwa vulve kirimo iminwa n’agace ka clitoris.",
        },
        modelUrl: '$_modelBase/female-anatomy.glb',
        hotspots: [
          Hotspot(
            id: 'hs_fa_ovary',
            number: 1,
            title: 'Ovaries',
            description:
                'Two almond-sized glands containing all lifetime eggs (1 million at birth, 300,000 to 400,000 at puberty). Produce oestrogen and progesterone.',
          ),
          Hotspot(
            id: 'hs_fa_uterus',
            number: 2,
            title: 'Uterus',
            description:
                'A hollow muscular organ (pear-sized, ~7.5 cm tall). Expands during pregnancy. Inner lining (endometrium) sheds monthly without pregnancy.',
          ),
          Hotspot(
            id: 'hs_fa_cervix',
            number: 3,
            title: 'Cervix',
            description:
                'Lower narrow passage between uterus and vagina. Produces cycle-varying mucus. Dilates during labour. Pap smear screening every 3 - 5 years (after age 25) is recommended.',
          ),
          Hotspot(
            id: 'hs_fa_vagina',
            number: 4,
            title: 'Vagina',
            description:
                'Flexible 8 to 12 cm muscular tube. Naturally acidic (pH 3.8 to 4.5) to prevent infection. Serves as birth canal and menstrual passage.',
          ),
        ],
      ),
      LessonChapter(
        id: 'anatomy_c2',
        orderIndex: 2,
        title: 'Male reproductive system',
        localizedTitle: {
          'en': 'Male reproductive system',
          'fr': 'Système reproducteur masculin',
          'rw': "Imyanya myibarukiro y'umugabo",
        },
        narrationText:
            'Testes produce sperm and testosterone. Sperm mature in the epididymis. During ejaculation, sperm travel through the vas deferens. Prostate and seminal vesicles add fluid.',
        localizedNarration: {
          'en':
              'The male reproductive system produces, stores, and delivers sperm. The testes produce sperm and testosterone. Sperm mature in the epididymis over about two weeks. During ejaculation, sperm travel through the vas deferens to the urethra. The prostate gland and seminal vesicles add fluid that nourishes sperm. A healthy ejaculation contains 40 million to 1.2 billion sperm.',
          'fr':
              "Le système reproducteur masculin produit, stocke et délivre des spermatozoïdes. Les testicules produisent spermatozoïdes et testostérone. Ils mûrissent dans l'épididyme (2 semaines). Lors de l'éjaculation, ils passent par le canal déférent. La prostate et les vésicules séminales ajoutent du liquide nutritif.",
          'rw':
              "Imyanya myibarukiro y’umugabo itanga, ibika kandi ikohereza intanga ngabo. Udusabo tw’intanga dutanga intanga ngabo na testosterone. Intanga ngabo zikurira mu muyoboro wa epididymis. Mu gihe cyo gusohora, zinyura mu muyoboro wa vas deferens zikagera mu nkari/umuyoboro usohora amasohoro.",
        },
        modelUrl: '$_modelBase/male-anatomy.glb',
        hotspots: [
          Hotspot(
            id: 'hs_ma_testes',
            number: 1,
            title: 'Testes',
            description:
                'Two oval glands in the scrotum producing 200 - 300 million sperm/day and testosterone. Kept 2 - 3°C cooler than body temperature for optimal sperm production.',
          ),
          Hotspot(
            id: 'hs_ma_epididymis',
            number: 2,
            title: 'Epididymis',
            description:
                'Coiled tube on the back of each testis. Sperm mature here over 2 - 3 weeks, gaining mobility. Mature sperm are stored here until ejaculation.',
          ),
          Hotspot(
            id: 'hs_ma_prostate',
            number: 3,
            title: 'Prostate gland',
            description:
                'Walnut-sized organ around the urethra. Produces alkaline fluid (20 - 30% of semen) that neutralises vaginal acidity. Health checks recommended after age 50.',
          ),
        ],
      ),
      LessonChapter(
        id: 'anatomy_c3',
        orderIndex: 3,
        title: 'Fertilisation & conception',
        localizedTitle: {
          'en': 'Fertilisation & conception',
          'fr': 'Fécondation et conception',
          'rw': 'Gusama n’ikorwa ry’inda',
        },
        narrationText:
            'One sperm penetrates the egg in the fallopian tube. The zygote divides as it travels to the uterus, implanting 6 to 10 days later. Implantation triggers hCG (detected by pregnancy tests).',
        localizedNarration: {
          'en':
              'Fertilisation occurs when one sperm penetrates and fuses with an egg (usually in the fallopian tube). The fertilised egg (now a zygote) divides as it travels to the uterus. After 6-10 days, it implants into the endometrium. Implantation triggers production of hCG (the hormone detected by pregnancy tests).',
          'fr':
              "La fécondation se produit lorsqu'un spermatozoïde pénètre dans un ovule, généralement dans la trompe de Fallope. Le zygote se divise en se déplaçant vers l'utérus. Après 6 à 10 jours, il s'implante dans l'endomètre. L'implantation déclenche la production d'hCG.",
          'rw':
              "Gusama kuba iyo intanga ngabo imwe yinjiye mu ntanga ngore, akenshi bibera mu muyoboro w’intanga ngore. Intanga yasamwe (zygote) igenda yigabanyamo igana muri nyababyeyi. Nyuma y’iminsi 6 kugeza kuri 10, yifatanya n’umwenda wa nyababyeyi (endometri). Ibyo bituma hCG itangira kuboneka mu mubiri.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'anatomy_c4',
        orderIndex: 4,
        title: 'Hormones & puberty',
        localizedTitle: {
          'en': 'Hormones & puberty',
          'fr': 'Hormones et puberté',
          'rw': 'Imisemburo n’ubugimbi/ubwangavu',
        },
        narrationText:
            'GnRH from the hypothalamus triggers FSH and LH. In females: oestrogen drives breast development and menarche. In males: testosterone drives testicular growth and voice deepening.',
        localizedNarration: {
          'en':
              'Puberty is driven by GnRH from the hypothalamus, triggering FSH and LH from the pituitary gland. In bodies with ovaries, oestrogen causes breast development, widening hips, pubic hair, and menarche. In bodies with testes, testosterone causes testicular growth, voice deepening, body hair, and ejaculation ability. Puberty typically starts age 8 - 13 (females) or 9 - 14 (males).',
          'fr':
              "La puberté est déclenchée par la GnRH de l'hypothalamus, stimulant FSH et LH de l'hypophyse. Chez les femmes, les œstrogènes provoquent le développement des seins, l'élargissement des hanches et la ménarche. Chez les hommes, la testostérone entraîne la croissance testiculaire et l'approfondissement de la voix.",
          'rw':
              "Ubugimbi n’ubwangavu butangizwa na GnRH iva muri hypothalamus, igatuma FSH na LH bisohoka. Ku bakobwa, estrogene itera gukura kw’amabere, kwaguka kw’amatako no gutangira imihango. Ku bahungu, testosterone itera gukura kw’imyanya ndangagitsina, kwijima kw’ijwi no kwiyongera k’imisatsi ku mubiri.",
        },
        hotspots: [],
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Lesson 4   Tracking Cramps & Flow (Menstrual Health)
  // ─────────────────────────────────────────────────────────────────────────
  'cramps_flow': Lesson(
    id: 'cramps_flow',
    title: 'Tracking cramps & flow',
    localizedTitle: {
      'en': 'Tracking cramps & flow',
      'fr': 'Suivre les crampes et les flux',
      'rw': "Gukurikirana ububabare n'ubwinshi bw'imihango",
    },
    category: LessonCategory.menstrualHealth,
    durationMinutes: 6,
    chapters: [
      LessonChapter(
        id: 'cramps_c0',
        orderIndex: 0,
        title: 'Why track?',
        localizedTitle: {
          'en': 'Why track?',
          'fr': 'Pourquoi suivre ?',
          'rw': 'Kuki gukurikirana?',
        },
        narrationText:
            'Tracking flow and cramps helps identify personal patterns and anticipate heavier days, and gives healthcare providers accurate information.',
        localizedNarration: {
          'en':
              'Tracking your menstrual flow and cramp intensity helps you identify your personal patterns. With a few months of tracking, you can anticipate heavier days, plan activities, and recognise changes that might indicate a health issue. Tracking also gives healthcare providers accurate information about your cycle.',
          'fr':
              "Suivre les flux et les crampes aide à identifier les schémas personnels. Après quelques mois, vous pouvez anticiper les jours plus importants et remarquer des changements signalant des problèmes de santé.",
          'rw':
              "Gukurikirana umubare w’amaraso n’ububabare bw’imihango bigufasha kumenya imiterere yawe bwite. Nyuma y’amezi make ushobora guteganya iminsi ikomeye, gutunganya gahunda zawe no kubona impinduka zishobora kuba ikimenyetso cy’ikibazo cy’ubuzima.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'cramps_c1',
        orderIndex: 1,
        title: 'Types of flow',
        localizedTitle: {
          'en': 'Types of flow',
          'fr': 'Types de flux',
          'rw': 'Ubwoko bw’umuvuduko w’imihango',
        },
        narrationText:
            'Light: one pad per day. Moderate: change every 3 to 4 hours. Heavy: change every 1 to 2 hours. More than 80 mL per cycle may be heavy menstrual bleeding requiring evaluation.',
        localizedNarration: {
          'en':
              'Menstrual flow varies from person to person. Light flow requires one pad or tampon per day. Moderate flow: change every 3 - 4 hours. Heavy flow: change every 1 - 2 hours. Losing more than 80 mL per cycle is considered heavy menstrual bleeding and can cause anaemia. Dark brown blood at the start or end is normal older blood.',
          'fr':
              "Le flux menstruel varie d'une personne à l'autre. Flux léger : un protège-slip par jour. Modéré : changement toutes les 3 - 4 heures. Abondant : toutes les 1 - 2 heures. Plus de 80 ml par cycle est abondant et peut causer une anémie.",
          'rw':
              "Imihango itandukana ku muntu n’undi. Uko ari mike: ushobora guhindura pad rimwe ku munsi. Uko ari hagati: guhindura nyuma y’amasaha 3 kugeza kuri 4. Uko ari nyinshi: guhindura nyuma y’amasaha 1 kugeza kuri 2. Kurenga mililitiro 80 mu kwezi bishobora kuba imihango myinshi ikwiye gusuzumwa n’umuganga.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'cramps_c2',
        orderIndex: 2,
        title: 'Managing cramps',
        localizedTitle: {
          'en': 'Managing cramps',
          'fr': 'Gérer les crampes',
          'rw': 'Uko wagabanya ububabare',
        },
        narrationText:
            'Heat therapy (15 to 20 min). Ibuprofen or naproxen taken early. Gentle exercise releases endorphins. Magnesium-rich foods may reduce cramping.',
        localizedNarration: {
          'en':
              'Heat therapy is one of the most effective approaches. A hot water bottle applied to the lower abdomen for 15 - 20 minutes relaxes uterine muscles. Ibuprofen and naproxen reduce prostaglandins   starting before pain peaks is more effective. Gentle exercise releases endorphins. Magnesium-rich foods like leafy greens, nuts, and seeds may also reduce cramping.',
          'fr':
              "La thermothérapie est très efficace. Une bouillotte pendant 15 - 20 minutes détend les muscles utérins. L'ibuprofène et le naproxène réduisent les prostaglandines   les prendre avant le pic de douleur est plus efficace. L'exercice doux libère des endorphines.",
          'rw':
              "Ubushyuhe ni bumwe mu buryo bwiza bwo kugabanya ububabare: shyira ikintu gishyushye ku nda yo hasi iminota 15 kugeza kuri 20. Ibuprofen na naproxen bigabanya prostaglandins, kandi bifasha kurushaho iyo bifashwe mbere y’uko ububabare bukomera. Siporo yoroshye irekura endorphins zifasha kugabanya ububabare.",
        },
        hotspots: [],
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Lesson 5   Getting Tested (HIV & STI)
  // ─────────────────────────────────────────────────────────────────────────
  'getting_tested': Lesson(
    id: 'getting_tested',
    title: 'Getting tested: what happens',
    localizedTitle: {
      'en': 'Getting tested: what happens',
      'fr': 'Se faire dépister : que se passe-t-il ?',
      'rw': 'Kwipimisha: uko bikorwa',
    },
    category: LessonCategory.hivSti,
    durationMinutes: 5,
    chapters: [
      LessonChapter(
        id: 'tested_c0',
        orderIndex: 0,
        title: 'Why get tested?',
        localizedTitle: {
          'en': 'Why get tested?',
          'fr': 'Pourquoi se faire dépister ?',
          'rw': 'Kuki kwipimisha?',
        },
        narrationText:
            'HIV often has no symptoms for years. Testing is the only reliable way to know your status. In Rwanda, free and confidential testing is at every health centre.',
        localizedNarration: {
          'en':
              'HIV often has no symptoms for years. Many STIs also show no signs. Testing is the only reliable way to know your status. In Rwanda, HIV testing is free, confidential, and available at every health centre for all people aged 15 and above. Knowing your status   positive or negative   empowers you to protect your health and the health of others.',
          'fr':
              "Le VIH ne présente souvent aucun symptôme pendant des années. Le dépistage est le seul moyen fiable de connaître son statut. Au Rwanda, le dépistage est gratuit et confidentiel dans tous les centres de santé pour les personnes de 15 ans et plus.",
          'rw':
              "VIH ishobora kumara imyaka idatanga ibimenyetso. Ni yo mpamvu kwipimisha ari bwo buryo bwizewe bwo kumenya uko uhagaze. Mu Rwanda, kwipimisha VIH ni ubuntu, bikorwa mu ibanga kandi biboneka ku bigo nderabuzima byose ku bafite imyaka 15 kuzamura.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'tested_c1',
        orderIndex: 1,
        title: 'What to expect',
        localizedTitle: {
          'en': 'What to expect',
          'fr': 'À quoi s’attendre',
          'rw': 'Ibyo uteganya gusanga',
        },
        narrationText:
            'Rwanda HIV testing: pre-test counselling, then a fingertip blood sample gives results in 20 minutes. Post-test counselling explains results and next steps. Under an hour total.',
        localizedNarration: {
          'en':
              'At a Rwanda health centre, HIV testing follows three steps: pre-test counselling explains the process. The test uses a rapid antigen and antibody test   a fingertip blood sample gives results in about 20 minutes. A second confirmatory test is done if the first is reactive. Post-test counselling explains your result and next steps. The entire process takes less than one hour. No fasting needed.',
          'fr':
              "Dans un centre de santé rwandais, le test suit 3 étapes : counseling pré-test, test rapide (résultats en 20 minutes depuis une goutte de sang au bout du doigt), et counseling post-test. L'ensemble prend moins d'une heure. Aucun jeûne requis.",
          'rw':
              "Mu kigo nderabuzima, kwipimisha gikurikiza ibyiciro bitatu: ubanza guhabwa inama, hagakurikiraho ikizamini cy’amaraso yo ku rutoki gitanga ibisubizo mu minota nka 20, hanyuma ugahabwa inama y’ibikurikiraho. Ubusanzwe byose birangira mu gihe kitarenga isaha.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'tested_c2',
        orderIndex: 2,
        title: 'Understanding your results',
        localizedTitle: {
          'en': 'Understanding your results',
          'fr': 'Comprendre vos résultats',
          'rw': 'Gusobanukirwa ibisubizo',
        },
        narrationText:
            'Non-reactive: no HIV detected   retest if last exposure was within 90 days. Reactive: confirmatory test needed. If positive, same-day ART enrolment is possible in Rwanda.',
        localizedNarration: {
          'en':
              'A non-reactive result means no HIV was detected. If your last potential exposure was within 90 days   the window period   retest in 3 months. A reactive result triggers a confirmatory test   not a final diagnosis yet. If confirmed positive, same-day enrolment in Rwanda\'s national ART programme is possible. A positive result is not a death sentence   with ART, people with HIV live full, healthy lives.',
          'fr':
              "Non réactif : pas de VIH détecté. Retester dans 3 mois si la dernière exposition remonte à moins de 90 jours. Réactif : test confirmatoire nécessaire. Si positif confirmé, l'inscription au programme ARV le jour même est possible au Rwanda.",
          'rw':
              "Igisubizo kitagaragaza VIH bivuze ko nta virusi yabonetse icyo gihe. Niba ufite ibyago byabaye mu minsi 90 ishize, ugomba kongera kwipimisha nyuma y’amezi 3. Igisubizo kigaragaza ibyago bisaba ikizamini cyo kwemeza. Niba byemejwe ko ufite VIH, ushobora gutangira ART uwo munsi.",
        },
        hotspots: [],
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Lesson 6   Puberty & Body Changes (Anatomy)
  // ─────────────────────────────────────────────────────────────────────────
  'puberty_changes': Lesson(
    id: 'puberty_changes',
    title: 'Puberty & body changes',
    localizedTitle: {
      'en': 'Puberty & body changes',
      'fr': 'Puberté et changements corporels',
      'rw': "Ubugimbi n’ubwangavu: impinduka z'umubiri",
    },
    category: LessonCategory.anatomy,
    durationMinutes: 9,
    chapters: [
      LessonChapter(
        id: 'puberty_c0',
        orderIndex: 0,
        title: 'What is puberty?',
        localizedTitle: {
          'en': 'What is puberty?',
          'fr': 'Qu’est-ce que la puberté ?',
          'rw': 'Ubugimbi n’ubwangavu ni iki?',
        },
        narrationText:
            'Puberty is the biological transition to adult reproductive capacity. The hypothalamus releases GnRH, triggering FSH and LH. Typically starts age 8 to 13 (females) or 9 to 14 (males).',
        localizedNarration: {
          'en':
              'Puberty is the stage when a child\'s body develops into an adult body capable of reproduction. The hypothalamus secretes GnRH, which signals the pituitary gland to release FSH and LH. These hormones tell the ovaries to produce oestrogen and the testes to produce testosterone. Puberty starts between ages 8 and 13 for females and 9 and 14 for males. Timing is influenced by genetics, nutrition, and overall health.',
          'fr':
              "La puberté est la phase où le corps d'un enfant se développe en corps adulte capable de se reproduire. L'hypothalamus sécrète la GnRH, signalant à l'hypophyse de libérer FSH et LH. Ces hormones déclenchent la production d'œstrogènes et de testostérone. Elle commence entre 8 et 13 ans (femmes) ou 9 et 14 ans (hommes).",
          'rw':
              "Ubugimbi n’ubwangavu ni igihe umubiri w’umwana uhinduka ugatangira kugira ubushobozi bwo kororoka. Hypothalamus isohora GnRH, igatuma pituwitari isohora FSH na LH. Iyi misemburo ituma intangangore zisohora estrogene n’udusabo tw’intanga tugasohora testosterone.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'puberty_c1',
        orderIndex: 1,
        title: 'Changes in female bodies',
        localizedTitle: {
          'en': 'Changes in female bodies',
          'fr': 'Changements chez les filles',
          'rw': 'Impinduka ku mubiri w’umukobwa',
        },
        narrationText:
            'First sign: breast development (thelarche) age 8 to 13. Then pubic hair, growth spurt (8 cm/year), hip widening. First period (menarche) about 2 years after thelarche. Average in Rwanda: age 13.',
        localizedNarration: {
          'en':
              'The first sign of puberty in females is usually breast development   thelarche   beginning between ages 8 and 13. Pubic and underarm hair then grows. A growth spurt of up to 8 centimetres per year occurs. Hips widen. Vaginal discharge   clear or white, mild smell   begins normally. The first period   menarche   usually occurs about 2 years after breast development. In Rwanda, the average age of menarche is around 13.',
          'fr':
              "Le premier signe de puberté chez les femmes est le développement des seins   la thélarche   entre 8 et 13 ans. Les poils pubiens poussent ensuite. Poussée de croissance jusqu'à 8 cm/an. Les hanches s'élargissent. Les premières règles surviennent environ 2 ans après les seins. Au Rwanda, l'âge moyen est 13 ans.",
          'rw':
              "Ku bakobwa, akenshi ikimenyetso cya mbere ni gukura kw’amabere hagati y’imyaka 8 na 13. Hanyuma hakaza imisatsi yo ku myanya ndangagitsina no mu kwaha, umubiri ukiyongera mu burebure, n’amatako akaguka. Imihango ya mbere ikunze kuza nyuma y’imyaka nk’ibiri amabere atangiye gukura.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'puberty_c2',
        orderIndex: 2,
        title: 'Changes in male bodies',
        localizedTitle: {
          'en': 'Changes in male bodies',
          'fr': 'Changements chez les garçons',
          'rw': 'Impinduka ku mubiri w’umuhungu',
        },
        narrationText:
            'First sign: testicular growth age 9 to 14. Then pubic and facial hair, growth spurt (10 cm/year), voice deepening, penis growth. Spermarche and sperm production begin.',
        localizedNarration: {
          'en':
              'The first sign of puberty in males is usually testicular growth, beginning between ages 9 and 14. Pubic and underarm hair grows, followed by facial hair. A growth spurt of up to 10 centimetres per year occurs. The voice deepens as the larynx enlarges. The penis grows. Muscle mass increases. First ejaculation   spermarche   and sperm production begin. Oilier skin, acne, and increased body odour are common.',
          'fr':
              "Le premier signe de puberté chez les hommes est la croissance testiculaire, entre 9 et 14 ans. Les poils pubiens et faciaux poussent ensuite. Poussée de croissance jusqu'à 10 cm/an. La voix mue. Le pénis se développe. La masse musculaire augmente. La première éjaculation   spémarche   commence.",
          'rw':
              "Ku bahungu, ikimenyetso cya mbere ni ugukura kw’udusabo tw’intanga hagati y’imyaka 9 na 14. Hiyongeraho imisatsi ku myanya ndangagitsina no ku maso, ijwi rikajya hasi, umubiri ukiyongera mu burebure, n’imikaya ikiyongera. Intanga ngabo zitangira gukorwa ndetse no gusohora bwa mbere bikaboneka.",
        },
        hotspots: [],
      ),
      LessonChapter(
        id: 'puberty_c3',
        orderIndex: 3,
        title: 'Emotional changes & self-care',
        localizedTitle: {
          'en': 'Emotional changes & self-care',
          'fr': 'Changements émotionnels et soins personnels',
          'rw': 'Impinduka z’amarangamutima no kwiyitaho',
        },
        narrationText:
            "Intense emotions are normal and temporary. Good hygiene is essential during puberty. Rwanda's Isange One Stop Centres offer confidential support for young people.",
        localizedNarration: {
          'en':
              'Hormonal changes affect emotions, mood, and self-image during puberty. Intense feelings are normal and temporary. The brain continues developing throughout adolescence. Daily bathing, clean underwear, and proper menstrual hygiene are especially important. If overwhelmed, speaking to a trusted adult, school counsellor, or community health worker is a sign of strength. In Rwanda, Isange One Stop Centres provide confidential support.',
          'fr':
              "Les changements hormonaux affectent les émotions pendant la puberté. Des sentiments intenses sont normaux et temporaires. Le cerveau continue de se développer tout au long de l'adolescence. Une bonne hygiène quotidienne est particulièrement importante. Parler à un adulte de confiance est un signe de force. Les centres Isange One Stop du Rwanda offrent un soutien confidentiel.",
          'rw':
              "Impinduka z’imisemburo zigira ingaruka ku marangamutima no ku mitekerereze. Kumva ubabaye, urakaye cyangwa wishimye cyane bishobora kuba ibisanzwe muri iki gihe. Isuku ya buri munsi ni ingenzi: kwoga, kwambara imyenda isukuye no kwita ku isuku y’imihango. Niba wumva bikuremereye, vugana n’umuntu mukuru wizeye cyangwa umujyanama; Isange One Stop Centers zitanga ubufasha bw’ibanga.",
        },
        hotspots: [],
      ),
    ],
  ),
};
