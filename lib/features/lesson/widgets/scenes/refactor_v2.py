import re

with open('your_cycle_chapters.dart', 'r') as f:
    content = f.read()

if "package:urungano/l10n/app_localizations.dart" not in content:
    content = content.replace("import 'lesson_animation_primitives.dart';", "import 'lesson_animation_primitives.dart';\nimport 'package:urungano/l10n/app_localizations.dart';")

# 1. Ch0 _phases
content = re.sub(
    r'  static const _phases = \[\n.*?\];',
    r'''  static List<_PD> _getPhases(AppLocalizations l) => [
    _PD(l.cyclePhaseMenstrual, l.cyclePhaseMenstrualDays, kRose, 3.0, 0.8, l.cyclePhaseMenstrualDesc),
    _PD(l.cyclePhaseFollicular, l.cyclePhaseFollicularDays, kAmber, 10.0, 0.0, l.cyclePhaseFollicularDesc),
    _PD(l.cyclePhaseOvulation, l.cyclePhaseOvulationDay, kSage, 14.0, 0.0, l.cyclePhaseOvulationDesc),
    _PD(l.cyclePhaseLuteal, l.cyclePhaseLutealDays, kRoseDark, 22.0, 0.0, l.cyclePhaseLutealDesc),
  ];''',
    content, flags=re.DOTALL
)

content = content.replace('_phases[_autoPhase]', '_getPhases(AppLocalizations.of(context)!)[_autoPhase]')
content = content.replace('_phases[i]', '_getPhases(AppLocalizations.of(context)!)[i]')

# 2. Ch0 text
content = content.replace("label: 'Drag to rotate'", "label: AppLocalizations.of(context)!.cycleDragHint.split(' · ')[0]")
content = content.replace("label: 'Pinch to zoom'", "label: AppLocalizations.of(context)!.cycleDragHint.split(' · ')[1]")
content = content.replace("label: 'Double-tap to reset'", "label: AppLocalizations.of(context)!.cycleDragHint.split(' · ')[2]")
content = content.replace("label: 'Close'", "label: AppLocalizations.of(context)!.cycleCloseBtn")
content = content.replace("label: 'Phases'", "label: AppLocalizations.of(context)!.cyclePhasesBtn")
content = content.replace("label: _showLabels ? 'Hide labels' : 'Labels'", "label: _showLabels ? AppLocalizations.of(context)!.cycleHideLabels : AppLocalizations.of(context)!.cycleShowLabels")
content = content.replace("Text('Day ${_day.toInt()}'", "Text(AppLocalizations.of(context)!.cycleDayBadge('${_day.toInt()}')")


# 3. UterusPainter
content = re.sub(
    r'  const UterusPainter\(\{\n    required this\.t,\n    required this\.activeHs,\n    required this\.showLabels,\n    required this\.zoom,\n    required this\.pan,\n  \}\);',
    r'''  const UterusPainter({
    required this.t,
    required this.activeHs,
    required this.showLabels,
    required this.zoom,
    required this.pan,
    required this.l,
  });
  final AppLocalizations l;''',
    content
)

content = re.sub(
    r'    const _labels = \[\n      \(Offset\(170, -110\).*?\];',
    r'''    final _labels = [
      (Offset(170, -110), l.cycleAnatomyFallopian, kSage, Alignment.centerLeft),
      (Offset(0, -145), l.cycleAnatomyUterineFundus, kPlum, Alignment.bottomCenter),
      (Offset(-210, -35), l.cycleAnatomyOvary, kAmber, Alignment.centerRight),
      (Offset(-30, 40), l.cycleAnatomyEndometrium, kRose, Alignment.centerRight),
      (Offset(70, 80), l.cycleAnatomyMyometrium, kRoseDark, Alignment.centerLeft),
      (Offset(80, 180), l.cycleAnatomyCervix, kRoseDark, Alignment.centerLeft),
      (Offset(-30, 260), l.cycleAnatomyVagina, kRose, Alignment.centerRight),
      (Offset(140, 20), l.cycleAnatomyBroadLig, const Color(0xFFD4A830), Alignment.centerLeft),
      (Offset(-130, -50), l.cycleAnatomyOvarianLig, const Color(0xFFD4A830), Alignment.centerRight),
      (Offset(-80, -80), l.cycleAnatomyPerimetrium, const Color(0xFFC48B9F), Alignment.centerRight),
    ];''',
    content, flags=re.DOTALL
)
content = content.replace('pan: _pan,', 'pan: _pan, l: AppLocalizations.of(context)!,')


# 4. Ch1FemaleAnatomy _hs
content = re.sub(
    r'  static const _hs = \[\n.*?\];',
    r'''  List<_HS> _getHs(AppLocalizations l) => [
    _HS(0, l.cycleAnatomyOvary, kAmber, l.cycleCh1HsOvaryDesc),
    _HS(1, l.cycleAnatomyFallopian, kSage, l.cycleCh1HsFallopianDesc),
    _HS(2, l.cycleAnatomyEndometrium, kRose, l.cycleCh1HsEndometriumDesc),
    _HS(3, l.cycleAnatomyCervix, kRoseDark, l.cycleCh1HsCervixDesc),
  ];''',
    content, flags=re.DOTALL
)
content = content.replace('_hs[_active!]', '_getHs(AppLocalizations.of(context)!)[_active!]')
content = content.replace('_hs.map', '_getHs(AppLocalizations.of(context)!).map')


# 5. Ch2 _phases (name, rw, days, daysN, color, hormones, endoThick, bleed, detail)
content = re.sub(
    r'  static const _phases = \[\n.*?\];',
    r'''  static List<_P2> _getPhases(AppLocalizations l) => [
    _P2(l.cyclePhaseMenstrual, l.cyclePhaseMenstrual, l.cyclePhaseMenstrualDays, 5, kRose, l.cycleHormoneMenstrualLevel, 3.0, 0.8, l.cyclePhaseMenstrualDescAlt),
    _P2(l.cyclePhaseFollicular, l.cyclePhaseFollicular, l.cyclePhaseFollicularDays, 8, kAmber, l.cycleHormoneFollicularLevel, 10.0, 0.0, l.cyclePhaseFollicularDescAlt),
    _P2(l.cyclePhaseOvulation, l.cyclePhaseOvulation, l.cyclePhaseOvulationDay, 1, kSage, l.cycleHormoneOvulationLevel, 14.0, 0.0, l.cyclePhaseOvulationDescAlt),
    _P2(l.cyclePhaseLuteal, l.cyclePhaseLuteal, l.cyclePhaseLutealDays, 14, kRoseDark, l.cycleHormoneLutealLevel, 22.0, 0.0, l.cyclePhaseLutealDescAlt),
  ];''',
    content, flags=re.DOTALL
)
content = content.replace('_phases[_sel]', '_getPhases(AppLocalizations.of(context)!)[_sel]')

# Replace Text inside Ch2
content = content.replace("Text('Tap any phase on the wheel'", "Text(AppLocalizations.of(context)!.cycleTapWheelHint")


# 6. Ch3CrampsAndPain
content = re.sub(
    r'  static const _remedies = \[\n.*?\];',
    r'''  List<({String icon, String label, String detail, Color color})> _getRemedies(AppLocalizations l) => [
    (icon:'🌡', label:l.cycleCh3Heat, detail:l.cycleCh3HeatDesc, color: const Color(0xFFE8703A)),
    (icon:'💊', label:l.cycleCh3Ibuprofen, detail:l.cycleCh3IbuprofenDesc, color: kSage),
    (icon:'🧘', label:l.cycleCh3Exercise, detail:l.cycleCh3ExerciseDesc, color: kAmber),
    (icon:'💧', label:l.cycleCh3Hydration, detail:l.cycleCh3HydrationDesc, color: const Color(0xFF5B8DC8)),
  ];''',
    content, flags=re.DOTALL
)
content = content.replace("_remedies.indexed.map", "_getRemedies(AppLocalizations.of(context)!).indexed.map")
content = content.replace("Text('Pain intensity'", "Text(AppLocalizations.of(context)!.cycleCh3PainIntensity")
content = content.replace("Text('Cramps & pain'", "Text(AppLocalizations.of(context)!.cycleCh3Title")


# 7. Ch4TrackingYourCycle
content = content.replace("Text('Your cycle calendar'", "Text(AppLocalizations.of(context)!.cycleCh4Title")
content = content.replace("Text('Tap any day to log your period'", "Text(AppLocalizations.of(context)!.cycleCh4Subtitle")
content = content.replace("['M','T','W','T','F','S','S']", "[AppLocalizations.of(context)!.cycleCh4DayM,AppLocalizations.of(context)!.cycleCh4DayT,AppLocalizations.of(context)!.cycleCh4DayW,AppLocalizations.of(context)!.cycleCh4DayTh,AppLocalizations.of(context)!.cycleCh4DayF,AppLocalizations.of(context)!.cycleCh4DayS,AppLocalizations.of(context)!.cycleCh4DaySu]")
content = content.replace("Text('Next period predicted'", "Text(AppLocalizations.of(context)!.cycleCh4NextPeriod")
content = content.replace("Text('Day ${_len + 1}'", "Text(AppLocalizations.of(context)!.cycleDayBadge('${_len + 1}')")
content = content.replace("Text('in ${_len - (_period.isNotEmpty ? _period.reduce(math.max) : 5)} days'", "Text(AppLocalizations.of(context)!.cycleCh4InXDays('${_len - (_period.isNotEmpty ? _period.reduce(math.max) : 5)}')")
content = content.replace("_s('Cycle length', '$_len days', '21–35 normal')", "_s(AppLocalizations.of(context)!.cycleCh4CycleLen, AppLocalizations.of(context)!.cycleCh4DaysX('$_len'), AppLocalizations.of(context)!.cycleCh4CycleLenNorm)")
content = content.replace("_s('Period length', '${_period.length} days', '3–7 normal')", "_s(AppLocalizations.of(context)!.cycleCh4PeriodLen, AppLocalizations.of(context)!.cycleCh4DaysX('${_period.length}'), AppLocalizations.of(context)!.cycleCh4PeriodLenNorm)")
content = content.replace("_s('Ovulation', 'Day $_ov', '±2 days')", "_s(AppLocalizations.of(context)!.cycleCh4OvulationLabel, AppLocalizations.of(context)!.cycleDayBadge('$_ov'), AppLocalizations.of(context)!.cycleCh4OvulationNorm)")
content = content.replace("_s('Fertile window', 'Days 11–16', 'Sperm survives 5d')", "_s(AppLocalizations.of(context)!.cycleCh4FertileWindow, AppLocalizations.of(context)!.cycleCh4DaysRange, AppLocalizations.of(context)!.cycleCh4FertileNorm)")

content = content.replace("_LR('🩸', 'Period · tap to log/remove')", "_LR('🩸', AppLocalizations.of(context)!.cycleCh4LegendPeriod)")
content = content.replace("_LR('🥚', 'Ovulation day (Day 14)')", "_LR('🥚', AppLocalizations.of(context)!.cycleCh4LegendOvulation)")
content = content.replace("_LR('🌱', 'Fertile window (Days 11–16)')", "_LR('🌱', AppLocalizations.of(context)!.cycleCh4LegendFertile)")
content = content.replace("_LR('🔮', 'Predicted next period')", "_LR('🔮', AppLocalizations.of(context)!.cycleCh4LegendPredicted)")


# 8. Ch5CommonMyths
content = re.sub(
    r'  static const _cards = \[\n.*?\];',
    r'''  List<_MC> _getCards(AppLocalizations l) => [
    _MC(l.cycleCh5Myth1, l.cycleCh5Fact1, '🏃‍♀️'),
    _MC(l.cycleCh5Myth2, l.cycleCh5Fact2, '🩸'),
    _MC(l.cycleCh5Myth3, l.cycleCh5Fact3, '🤔'),
    _MC(l.cycleCh5Myth4, l.cycleCh5Fact4, '📅'),
    _MC(l.cycleCh5Myth5, l.cycleCh5Fact5, '💊'),
  ];''',
    content, flags=re.DOTALL
)
content = content.replace("for (int i = 0; i < _cards.length; i++)", "for (int i = 0; i < 5; i++)")
content = content.replace("_cards.length", "_getCards(AppLocalizations.of(context)!).length")
content = content.replace("card: _cards[i]", "card: _getCards(AppLocalizations.of(context)!)[i]")
content = content.replace("Text('Myth busters'", "Text(AppLocalizations.of(context)!.cycleCh5Title")
content = content.replace("Text('Tap a card to reveal the medical fact'", "Text(AppLocalizations.of(context)!.cycleCh5Subtitle")
content = content.replace("Text(_busted == 5 ? '🎉 All busted!' : '$_busted / 5 busted'", "Text(_busted == 5 ? AppLocalizations.of(context)!.cycleCh5AllBusted : AppLocalizations.of(context)!.cycleCh5XBusted('$_busted')")
content = content.replace("Text(showFact ? 'FACT ✓' : 'MYTH ✗'", "Text(showFact ? AppLocalizations.of(context)!.cycleCh5FactLabel : AppLocalizations.of(context)!.cycleCh5MythLabel")
content = content.replace("Text(showFact ? 'Tap again to see myth' : 'Tap to reveal fact'", "Text(showFact ? AppLocalizations.of(context)!.cycleCh5TapFact : AppLocalizations.of(context)!.cycleCh5TapMyth")


# 9. Sidebar Panels
content = content.replace("_Ch0State._phases[phaseIdx]", "_Ch0State._getPhases(AppLocalizations.of(context)!)[phaseIdx]")
content = content.replace("_Ch0State._phases[i]", "_Ch0State._getPhases(AppLocalizations.of(context)!)[i]")
content = content.replace("const Text('HORMONES'", "Text(AppLocalizations.of(context)!.cycleHormonesLabel")
content = content.replace("const Row(children: [\n                      _Leg(kRose, 'Oestrogen'), SizedBox(width: 12),\n                      _Leg(kSage, 'Prog.'), SizedBox(width: 12),\n                      _Leg(kAmber, 'LH'),\n                    ]),",
                          "Row(children: [\n                      _Leg(kRose, AppLocalizations.of(context)!.cycleOestrogen), const SizedBox(width: 12),\n                      _Leg(kSage, AppLocalizations.of(context)!.cycleProgesterone), const SizedBox(width: 12),\n                      _Leg(kAmber, AppLocalizations.of(context)!.cycleLH),\n                    ]),")
content = content.replace("const Text('PHASES'", "Text(AppLocalizations.of(context)!.cyclePhasesBtn")

content = content.replace("_Ch2State._phases[ch2Shared.selPhase]", "_Ch2State._getPhases(AppLocalizations.of(context)!)[ch2Shared.selPhase]")

with open('your_cycle_chapters.dart', 'w') as f:
    f.write(content)

