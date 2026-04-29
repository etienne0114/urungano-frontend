import json

# EN keys
en_keys = {
  "cycleDragHint": "Drag to rotate · Pinch to zoom · Double-tap to reset",
  "cycleTapWheelHint": "Tap any phase on the wheel",
  "cycleHideLabels": "Hide labels",
  "cycleShowLabels": "Labels",
  "cyclePhasesBtn": "Phases",
  "cycleCloseBtn": "Close",
  "cycleDayBadge": "Day {day}",
  "@cycleDayBadge": {
    "placeholders": {
      "day": {"type": "String"}
    }
  },
  "cycleHormonesLabel": "HORMONES",
  "cycleOestrogen": "Oestrogen",
  "cycleProgesterone": "Prog.",
  "cycleLH": "LH",
  "cycleFSH": "FSH",
  
  "cyclePhaseMenstrual": "Menstrual",
  "cyclePhaseFollicular": "Follicular",
  "cyclePhaseOvulation": "Ovulation",
  "cyclePhaseLuteal": "Luteal",

  "cyclePhaseMenstrualDays": "Days 1–5",
  "cyclePhaseFollicularDays": "Days 6–13",
  "cyclePhaseOvulationDay": "Day 14",
  "cyclePhaseLutealDays": "Days 15–28",

  "cyclePhaseMenstrualDesc": "The endometrial lining sheds. Prostaglandins cause uterine contractions. Hormone levels are at their lowest point in the cycle.",
  "cyclePhaseFollicularDesc": "FSH stimulates follicle growth. Rising oestrogen rebuilds the endometrium. Energy and mood often peak in this phase.",
  "cyclePhaseOvulationDesc": "LH surge triggers egg release from the dominant follicle. Peak fertility. Cervical mucus becomes clear and stretchy.",
  "cyclePhaseLutealDesc": "Corpus luteum secretes progesterone, maintaining the thickened endometrium. If no fertilisation, progesterone drops and menstruation begins.",

  "cyclePhaseMenstrualDescAlt": "The endometrium sheds. Prostaglandins cause uterine contractions expelling the lining. Hormone levels reach their lowest point.",
  "cyclePhaseFollicularDescAlt": "FSH stimulates several follicles. The dominant follicle produces oestrogen, rebuilding the endometrium and suppressing others.",
  "cyclePhaseOvulationDescAlt": "LH surge triggers rupture of the dominant follicle, releasing the egg into the fallopian tube. Peak fertility.",
  "cyclePhaseLutealDescAlt": "The corpus luteum produces progesterone, maintaining the endometrium. If no fertilisation, it degrades and the cycle restarts.",

  "cycleHormoneMenstrualLevel": "FSH ↓ LH ↓ Oestrogen ↓",
  "cycleHormoneFollicularLevel": "FSH ↑ Oestrogen ↑",
  "cycleHormoneOvulationLevel": "LH surge · Oestrogen peak",
  "cycleHormoneLutealLevel": "Progesterone ↑ Oestrogen ↑",

  "cycleAnatomyFallopian": "Fallopian tube",
  "cycleAnatomyUterineFundus": "Uterine fundus",
  "cycleAnatomyOvary": "Ovary",
  "cycleAnatomyEndometrium": "Endometrium",
  "cycleAnatomyMyometrium": "Myometrium",
  "cycleAnatomyCervix": "Cervix",
  "cycleAnatomyVagina": "Vagina",
  "cycleAnatomyBroadLig": "Broad ligament",
  "cycleAnatomyOvarianLig": "Ovarian lig.",
  "cycleAnatomyPerimetrium": "Perimetrium",

  "cycleCh1HsOvaryDesc": "Each ovary is ~3 cm and contains 300,000+ primordial follicles. Each month FSH stimulates several to grow — usually one matures and releases an egg at ovulation.",
  "cycleCh1HsFallopianDesc": "~10 cm long with finger-like fimbriae that sweep the released egg inward. Fertilisation by sperm most often occurs in the outer third of the tube.",
  "cycleCh1HsEndometriumDesc": "The inner mucosal lining. Thickness ranges from ~2 mm after menstruation to ~12 mm in the luteal phase. Shed as a period if no implantation occurs.",
  "cycleCh1HsCervixDesc": "Lower narrow neck of the uterus. Produces mucus that changes throughout the cycle — clear and stretchy at ovulation, thick and opaque at other times.",

  "cycleCh3Title": "Cramps & pain",
  "cycleCh3PainIntensity": "Pain intensity",
  "cycleCh3Heat": "Heat",
  "cycleCh3HeatDesc": "Relaxes muscle spasm, increases blood flow. Apply 15–20 min.",
  "cycleCh3Ibuprofen": "Ibuprofen",
  "cycleCh3IbuprofenDesc": "NSAIDs inhibit prostaglandin synthesis. Take 1–2h before peak pain.",
  "cycleCh3Exercise": "Exercise",
  "cycleCh3ExerciseDesc": "Endorphins reduce pain by ~50%. Walk, yoga, or light stretching.",
  "cycleCh3Hydration": "Hydration",
  "cycleCh3HydrationDesc": "Warm fluids reduce inflammation. Ginger and chamomile teas help.",

  "cycleCh4Title": "Your cycle calendar",
  "cycleCh4Subtitle": "Tap any day to log your period",
  "cycleCh4DayM": "M",
  "cycleCh4DayT": "T",
  "cycleCh4DayW": "W",
  "cycleCh4DayTh": "T",
  "cycleCh4DayF": "F",
  "cycleCh4DayS": "S",
  "cycleCh4DaySu": "S",
  "cycleCh4NextPeriod": "Next period predicted",
  "cycleCh4InXDays": "in {days} days",
  "@cycleCh4InXDays": {
    "placeholders": {
      "days": {"type": "String"}
    }
  },
  "cycleCh4CycleLen": "Cycle length",
  "cycleCh4CycleLenNorm": "21–35 normal",
  "cycleCh4PeriodLen": "Period length",
  "cycleCh4PeriodLenNorm": "3–7 normal",
  "cycleCh4OvulationLabel": "Ovulation",
  "cycleCh4OvulationNorm": "±2 days",
  "cycleCh4FertileWindow": "Fertile window",
  "cycleCh4FertileNorm": "Sperm survives 5d",
  "cycleCh4LegendPeriod": "Period · tap to log/remove",
  "cycleCh4LegendOvulation": "Ovulation day (Day 14)",
  "cycleCh4LegendFertile": "Fertile window (Days 11–16)",
  "cycleCh4LegendPredicted": "Predicted next period",
  "cycleCh4DaysX": "{days} days",
  "@cycleCh4DaysX": {
    "placeholders": {
      "days": {"type": "String"}
    }
  },
  "cycleCh4DaysRange": "Days 11–16",

  "cycleCh5Title": "Myth busters",
  "cycleCh5Subtitle": "Tap a card to reveal the medical fact",
  "cycleCh5AllBusted": "🎉 All busted!",
  "cycleCh5XBusted": "{count} / 5 busted",
  "@cycleCh5XBusted": {
    "placeholders": {
      "count": {"type": "String"}
    }
  },
  "cycleCh5FactLabel": "FACT ✓",
  "cycleCh5MythLabel": "MYTH ✗",
  "cycleCh5TapFact": "Tap again to see myth",
  "cycleCh5TapMyth": "Tap to reveal fact",

  "cycleCh5Myth1": "You cannot exercise during your period.",
  "cycleCh5Fact1": "Exercise releases endorphins, increasing blood flow and reducing cramp pain. Walking, yoga, and swimming are all safe and beneficial.",
  "cycleCh5Myth2": "Period blood is dirty or impure.",
  "cycleCh5Fact2": "Menstrual fluid is a healthy mix of blood, endometrial tissue, mucus, and vaginal secretions — a normal biological process with no toxins.",
  "cycleCh5Myth3": "You cannot get pregnant during your period.",
  "cycleCh5Fact3": "Sperm can survive 3–5 days in the reproductive tract. If ovulation follows soon after bleeding ends, pregnancy is possible.",
  "cycleCh5Myth4": "Irregular periods always signal a health problem.",
  "cycleCh5Fact4": "Stress, diet changes, travel, and exercise all affect cycle timing. A range of 21–35 days is entirely normal. Only persistent irregularity warrants investigation.",
  "cycleCh5Myth5": "Period pain is just something to endure — nothing helps.",
  "cycleCh5Fact5": "NSAIDs (ibuprofen/naproxen), heat therapy, and light exercise are clinically proven to significantly reduce dysmenorrhoea."
}

# FR keys
fr_keys = {
  "cycleDragHint": "Glissez pour faire pivoter · Pincez pour zoomer · Double-tapez pour réinitialiser",
  "cycleTapWheelHint": "Appuyez sur n'importe quelle phase sur la roue",
  "cycleHideLabels": "Masquer les étiquettes",
  "cycleShowLabels": "Étiquettes",
  "cyclePhasesBtn": "Phases",
  "cycleCloseBtn": "Fermer",
  "cycleDayBadge": "Jour {day}",
  "cycleHormonesLabel": "HORMONES",
  "cycleOestrogen": "Œstrogène",
  "cycleProgesterone": "Prog.",
  "cycleLH": "LH",
  "cycleFSH": "FSH",
  
  "cyclePhaseMenstrual": "Menstruelle",
  "cyclePhaseFollicular": "Folliculaire",
  "cyclePhaseOvulation": "Ovulation",
  "cyclePhaseLuteal": "Lutéale",

  "cyclePhaseMenstrualDays": "Jours 1–5",
  "cyclePhaseFollicularDays": "Jours 6–13",
  "cyclePhaseOvulationDay": "Jour 14",
  "cyclePhaseLutealDays": "Jours 15–28",

  "cyclePhaseMenstrualDesc": "La muqueuse endométriale se desquame. Les prostaglandines provoquent des contractions utérines. Les niveaux d'hormones sont au plus bas.",
  "cyclePhaseFollicularDesc": "La FSH stimule la croissance des follicules. L'œstrogène reconstitue l'endomètre. L'énergie et l'humeur atteignent souvent leur pic.",
  "cyclePhaseOvulationDesc": "Le pic de LH déclenche la libération de l'ovule. Fertilité maximale. La glaire cervicale devient claire et filante.",
  "cyclePhaseLutealDesc": "Le corps jaune sécrète la progestérone, maintenant l'endomètre. Sans fécondation, la progestérone chute et les règles commencent.",

  "cyclePhaseMenstrualDescAlt": "L'endomètre se desquame. Les prostaglandines causent des contractions pour expulser la muqueuse. Les hormones atteignent leur point le plus bas.",
  "cyclePhaseFollicularDescAlt": "La FSH stimule plusieurs follicules. Le follicule dominant produit l'œstrogène, reconstituant l'endomètre et supprimant les autres.",
  "cyclePhaseOvulationDescAlt": "Le pic de LH déclenche la rupture du follicule dominant, libérant l'ovule dans la trompe de Fallope. Fertilité maximale.",
  "cyclePhaseLutealDescAlt": "Le corps jaune produit la progestérone, maintenant l'endomètre. Sans fécondation, il se dégrade et le cycle recommence.",

  "cycleHormoneMenstrualLevel": "FSH ↓ LH ↓ Œstrogène ↓",
  "cycleHormoneFollicularLevel": "FSH ↑ Œstrogène ↑",
  "cycleHormoneOvulationLevel": "Pic LH · Pic Œstrogène",
  "cycleHormoneLutealLevel": "Progestérone ↑ Œstrogène ↑",

  "cycleAnatomyFallopian": "Trompe de Fallope",
  "cycleAnatomyUterineFundus": "Fond utérin",
  "cycleAnatomyOvary": "Ovaire",
  "cycleAnatomyEndometrium": "Endomètre",
  "cycleAnatomyMyometrium": "Myomètre",
  "cycleAnatomyCervix": "Col de l'utérus",
  "cycleAnatomyVagina": "Vagin",
  "cycleAnatomyBroadLig": "Ligament large",
  "cycleAnatomyOvarianLig": "Ligament ovarien",
  "cycleAnatomyPerimetrium": "Périmètre",

  "cycleCh1HsOvaryDesc": "Chaque ovaire mesure environ 3 cm et contient plus de 300 000 follicules primordiaux. Chaque mois, la FSH en stimule plusieurs, dont un mûrit pour l'ovulation.",
  "cycleCh1HsFallopianDesc": "D'une longueur de ~10 cm, avec des franges captant l'ovule libéré. La fécondation a le plus souvent lieu dans le tiers externe de la trompe.",
  "cycleCh1HsEndometriumDesc": "La muqueuse interne. Son épaisseur varie de ~2 mm après les règles à ~12 mm en phase lutéale. S'évacue si aucune implantation n'a lieu.",
  "cycleCh1HsCervixDesc": "La partie inférieure étroite de l'utérus. Produit du mucus qui change tout au long du cycle : clair à l'ovulation, épais et opaque le reste du temps.",

  "cycleCh3Title": "Crampes et douleurs",
  "cycleCh3PainIntensity": "Intensité de la douleur",
  "cycleCh3Heat": "Chaleur",
  "cycleCh3HeatDesc": "Détend les muscles, augmente le flux sanguin. Appliquer 15 à 20 min.",
  "cycleCh3Ibuprofen": "Ibuprofène",
  "cycleCh3IbuprofenDesc": "Les AINS inhibent les prostaglandines. Prendre 1 à 2 h avant le pic de douleur.",
  "cycleCh3Exercise": "Exercice",
  "cycleCh3ExerciseDesc": "Les endorphines réduisent la douleur d'environ 50%. Marche ou yoga.",
  "cycleCh3Hydration": "Hydratation",
  "cycleCh3HydrationDesc": "Les liquides chauds réduisent l'inflammation. Le thé au gingembre aide.",

  "cycleCh4Title": "Calendrier de votre cycle",
  "cycleCh4Subtitle": "Appuyez sur n'importe quel jour pour noter vos règles",
  "cycleCh4DayM": "L",
  "cycleCh4DayT": "M",
  "cycleCh4DayW": "M",
  "cycleCh4DayTh": "J",
  "cycleCh4DayF": "V",
  "cycleCh4DayS": "S",
  "cycleCh4DaySu": "D",
  "cycleCh4NextPeriod": "Prochaines règles (prévues)",
  "cycleCh4InXDays": "dans {days} jours",
  "cycleCh4CycleLen": "Durée du cycle",
  "cycleCh4CycleLenNorm": "21–35 normal",
  "cycleCh4PeriodLen": "Durée des règles",
  "cycleCh4PeriodLenNorm": "3–7 normal",
  "cycleCh4OvulationLabel": "Ovulation",
  "cycleCh4OvulationNorm": "±2 jours",
  "cycleCh4FertileWindow": "Période fertile",
  "cycleCh4FertileNorm": "Les spm survivent 5j",
  "cycleCh4LegendPeriod": "Règles · appuyez pour ajouter",
  "cycleCh4LegendOvulation": "Jour d'ovulation (Jour 14)",
  "cycleCh4LegendFertile": "Période fertile (Jours 11–16)",
  "cycleCh4LegendPredicted": "Prochaines règles prévues",
  "cycleCh4DaysX": "{days} jours",
  "cycleCh4DaysRange": "Jours 11–16",

  "cycleCh5Title": "Mythes ou Réalités",
  "cycleCh5Subtitle": "Appuyez sur une carte pour révéler le fait médical",
  "cycleCh5AllBusted": "🎉 Tous démentis !",
  "cycleCh5XBusted": "{count} / 5 démentis",
  "cycleCh5FactLabel": "FAIT ✓",
  "cycleCh5MythLabel": "MYTHE ✗",
  "cycleCh5TapFact": "Appuyez pour revoir le mythe",
  "cycleCh5TapMyth": "Appuyez pour révéler le fait",

  "cycleCh5Myth1": "On ne peut pas faire d'exercice pendant ses règles.",
  "cycleCh5Fact1": "L'exercice libère des endorphines, augmente le flux sanguin et réduit la douleur. La marche, le yoga et la natation sont sûrs et bénéfiques.",
  "cycleCh5Myth2": "Le sang des règles est sale ou impur.",
  "cycleCh5Fact2": "Le fluide menstruel est un mélange sain de sang, de tissu endométrial, de mucus et de sécrétions vaginales — un processus normal sans toxines.",
  "cycleCh5Myth3": "On ne peut pas tomber enceinte pendant ses règles.",
  "cycleCh5Fact3": "Les spermatozoïdes peuvent survivre 3 à 5 jours. Si l'ovulation suit peu après la fin des saignements, la grossesse est possible.",
  "cycleCh5Myth4": "Des règles irrégulières signalent toujours un problème de santé.",
  "cycleCh5Fact4": "Le stress, l'alimentation, les voyages et l'exercice affectent le cycle. Une plage de 21 à 35 jours est normale. Seule une irrégularité persistante justifie une consultation.",
  "cycleCh5Myth5": "La douleur des règles doit être endurée — rien n'y fait.",
  "cycleCh5Fact5": "Les AINS, la chaleur et l'exercice léger sont cliniquement prouvés pour réduire considérablement la dysménorrhée."
}

# RW keys
rw_keys = {
  "cycleDragHint": "Kanda ukurure · Pina kugira ngo wongere · Kanda kabiri",
  "cycleTapWheelHint": "Kanda ku cyiciro icyo ari cyo cyose ku ruziga",
  "cycleHideLabels": "Hisha amazina",
  "cycleShowLabels": "Amazina",
  "cyclePhasesBtn": "Ibyiciro",
  "cycleCloseBtn": "Funga",
  "cycleDayBadge": "Umunsi wa {day}",
  "cycleHormonesLabel": "IMISEMBURO",
  "cycleOestrogen": "Oestrogen",
  "cycleProgesterone": "Progesterone",
  "cycleLH": "LH",
  "cycleFSH": "FSH",
  
  "cyclePhaseMenstrual": "Imihango",
  "cyclePhaseFollicular": "Gukura kw'igi",
  "cyclePhaseOvulation": "Kurekura igi",
  "cyclePhaseLuteal": "Mbere y'imihango",

  "cyclePhaseMenstrualDays": "Iminsi 1–5",
  "cyclePhaseFollicularDays": "Iminsi 6–13",
  "cyclePhaseOvulationDay": "Umunsi 14",
  "cyclePhaseLutealDays": "Iminsi 15–28",

  "cyclePhaseMenstrualDesc": "Ururenda rwa nyababyeyi ruravaho. Prostaglandine zitera kwinyagambura kwa nyababyeyi. Imisemburo iri hasi cyane.",
  "cyclePhaseFollicularDesc": "FSH ituma udufuka tw'amagi dukura. Oestrogen yongera kubaka ururenda rwa nyababyeyi. Imbaraga n'akanyamuneza biriyongera.",
  "cyclePhaseOvulationDesc": "Ubwiyongere bwa LH butuma igi rirekurwa. Igihe cy'uburumbuke bwo hejuru. Urukonda ruba rwiza kandi rukweduka.",
  "cyclePhaseLutealDesc": "Korupusi luteumu (Corpus luteum) ivubura progesterone. Iyo igi ridahuye n'intanga ngabo, progesterone iragabanyuka imihango igatangira.",

  "cyclePhaseMenstrualDescAlt": "Ururenda ruravaho. Prostaglandine zituma nyababyeyi yikanya kugira ngo ivaneho ururenda. Imisemburo igera hasi.",
  "cyclePhaseFollicularDescAlt": "FSH itera gukura kw'amagi menshi. Igi rikuru rivubura oestrogen rikaba ari naryo rihagarika andi.",
  "cyclePhaseOvulationDescAlt": "LH itera guturika kw'agafuka karimo igi, rikinjira mu muheha w'intanga. Uburumbuke bugeze hejuru.",
  "cyclePhaseLutealDescAlt": "Korupusi luteumu yongera progesterone kugira ngo ikomeze kubaka ururenda. Iyo nta gusama byabaye, imihango iragaruka.",

  "cycleHormoneMenstrualLevel": "FSH ↓ LH ↓ Oestrogen ↓",
  "cycleHormoneFollicularLevel": "FSH ↑ Oestrogen ↑",
  "cycleHormoneOvulationLevel": "Ubwiyongere bwa LH · Oestrogen ihagaze hejuru",
  "cycleHormoneLutealLevel": "Progesterone ↑ Oestrogen ↑",

  "cycleAnatomyFallopian": "Umuheha w'intanga",
  "cycleAnatomyUterineFundus": "Igisenge cya nyababyeyi",
  "cycleAnatomyOvary": "Intangangore",
  "cycleAnatomyEndometrium": "Ururenda rwa nyababyeyi",
  "cycleAnatomyMyometrium": "Miyometri",
  "cycleAnatomyCervix": "Inkondo y'umura",
  "cycleAnatomyVagina": "Igituba",
  "cycleAnatomyBroadLig": "Umuzi mugari",
  "cycleAnatomyOvarianLig": "Umuzi w'intangangore",
  "cycleAnatomyPerimetrium": "Perimetri",

  "cycleCh1HsOvaryDesc": "Buri ntangangore ireshya na cm ~3 kandi ibonekamo udufuka (follicles) turenga 300,000. Buri kwezi, FSH ikura tumwe muri two, ariko kamwe niko gasohora igi.",
  "cycleCh1HsFallopianDesc": "Umuheha ureshya na cm ~10 ufite udusonga dukurura igi. Gusama bikunda kubera mu gice cy'inyuma cy'uyu muheha.",
  "cycleCh1HsEndometriumDesc": "Ururenda rw'imbere. Umubyimba warwo uva kuri mm ~2 nyuma y'imihango ukagera kuri mm ~12 mbere yayo. Ruvaho mu gihe cy'imihango iyo gusama bitabaye.",
  "cycleCh1HsCervixDesc": "Igice cyo hasi kifunganye cya nyababyeyi. Kivubura urukonda ruhinduka bitewe n'igihe cy'ukwezi — rurakweduka mu gihe cy'uburumbuke.",

  "cycleCh3Title": "Ibinya n'ububabare",
  "cycleCh3PainIntensity": "Urubarure rw'ububabare",
  "cycleCh3Heat": "Ubushyuhe",
  "cycleCh3HeatDesc": "Bworoshya imikaya, byongera amaraso. Koresha min 15-20.",
  "cycleCh3Ibuprofen": "Ibuprofen",
  "cycleCh3IbuprofenDesc": "Ifasha kugabanya ububabare. Fata amasaha 1-2 mbere y'ububabare bukomeye.",
  "cycleCh3Exercise": "Imyitozo",
  "cycleCh3ExerciseDesc": "Kugenda cyangwa yoga bigabanya ububabare kugeza kuri 50%.",
  "cycleCh3Hydration": "Kunywa amazi",
  "cycleCh3HydrationDesc": "Ibyo kunywa bishyushye, nk'icyayi cy'icyinzari bifasha.",

  "cycleCh4Title": "Kalendari y'ukwezi kwawe",
  "cycleCh4Subtitle": "Kanda ku munsi uwo ari wo wose wibuke imihango",
  "cycleCh4DayM": "L",
  "cycleCh4DayT": "K",
  "cycleCh4DayW": "K",
  "cycleCh4DayTh": "K",
  "cycleCh4DayF": "G",
  "cycleCh4DayS": "G",
  "cycleCh4DaySu": "K",
  "cycleCh4NextPeriod": "Imihango itaha iteganijwe",
  "cycleCh4InXDays": "Mu minsi {days}",
  "cycleCh4CycleLen": "Uburebure bw'ukwezi",
  "cycleCh4CycleLenNorm": "Iminsi 21–35 ni ibisanzwe",
  "cycleCh4PeriodLen": "Uburebure bw'imihango",
  "cycleCh4PeriodLenNorm": "Iminsi 3–7 ni ibisanzwe",
  "cycleCh4OvulationLabel": "Kurekura igi",
  "cycleCh4OvulationNorm": "Iminsi ±2",
  "cycleCh4FertileWindow": "Igihe cy'uburumbuke",
  "cycleCh4FertileNorm": "Intanga ibaho iminsi 5",
  "cycleCh4LegendPeriod": "Imihango · kanda ngo wongere/ukureho",
  "cycleCh4LegendOvulation": "Umunsi wo kurekura igi (Umunsi 14)",
  "cycleCh4LegendFertile": "Igihe cy'uburumbuke (Iminsi 11–16)",
  "cycleCh4LegendPredicted": "Imihango itaha iteganijwe",
  "cycleCh4DaysX": "Iminsi {days}",
  "cycleCh4DaysRange": "Iminsi 11–16",

  "cycleCh5Title": "Ukuri cyangwa Ikinyoma",
  "cycleCh5Subtitle": "Kanda ku ikarita urebe ukuri kwa muganga",
  "cycleCh5AllBusted": "🎉 Byose byasobanuwe!",
  "cycleCh5XBusted": "{count} / 5 byasobanuwe",
  "cycleCh5FactLabel": "UKURI ✓",
  "cycleCh5MythLabel": "IKINYOMA ✗",
  "cycleCh5TapFact": "Kanda wongere urebe ikinyoma",
  "cycleCh5TapMyth": "Kanda urebe ukuri",

  "cycleCh5Myth1": "Ntushobora gukora imyitozo ngororamubiri uri mu mihango.",
  "cycleCh5Fact1": "Imyitozo izamura ibyishimo n'amaraso, bigabanya ibinya. Kugenda, yoga no koga ni byiza cyane.",
  "cycleCh5Myth2": "Amaraso y'imihango ni mabi cyangwa yanduye.",
  "cycleCh5Fact2": "Amaraso y'imihango aba agizwe n'amaraso meza, inyama z'ururenda n'amazi yo mu gitsina — nta myanda y'uburozi ibamo.",
  "cycleCh5Myth3": "Ntushobora gusama uri mu mihango.",
  "cycleCh5Fact3": "Intanga ngabo ishobora kubaho iminsi 3–5. Iyo igi rirekuwe vuba nyuma y'imihango, ushobora gusama.",
  "cycleCh5Myth4": "Imihango idahoraho yerekana uburwayi bubi.",
  "cycleCh5Fact4": "Umunaniro, imirire, n'ingendo bishobora guhindura ukwezi. Kuba hagati y'iminsi 21 na 35 ni ibisanzwe. Iyo bikabije nibwo ugomba kwivuza.",
  "cycleCh5Myth5": "Ububabare bw'imihango ugomba kwihangana ntakindi — nta muti wabwo.",
  "cycleCh5Fact5": "Imiti nka Ibuprofen, ubushyuhe, n'imyitozo byaragaragaye ko bigabanya cyane ububabare bw'imihango."
}

def update_json(filepath, new_keys):
    with open(filepath, 'r') as f:
        data = json.load(f)
    
    data.update(new_keys)
    
    with open(filepath, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

update_json('app_en.arb', en_keys)
update_json('app_fr.arb', fr_keys)
update_json('app_rw.arb', rw_keys)

