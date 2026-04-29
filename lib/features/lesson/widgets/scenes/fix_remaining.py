with open('your_cycle_chapters.dart', 'r') as f:
    content = f.read()

# Fix _hs
content = content.replace("_hs[_glow]", "_getHs(AppLocalizations.of(context)!)[_glow]")
content = content.replace("Text('${_hs[_glow]", "Text('${_getHs(AppLocalizations.of(context)!)[_glow]")

# Fix _phases in Ch2 (Line 1229 and 1238)
content = content.replace("_phases[i]", "_getPhases(AppLocalizations.of(context)!)[i]")
content = content.replace("_phases[_sel]", "_getPhases(AppLocalizations.of(context)!)[_sel]")
# Wait, Ch2 is using _getPhases correctly but maybe I missed a _phases?
content = content.replace("phases: _phases", "phases: _getPhases(AppLocalizations.of(context)!)")

# Fix _P2 in Ch2 _getPhases (Line 1238) - The script previously incorrectly used _PD for Ch2
content = content.replace(
    '''_PD(l.cyclePhaseMenstrual, l.cyclePhaseMenstrual, l.cyclePhaseMenstrualDays, 5, kRose, l.cycleHormoneMenstrualLevel, 3.0, 0.8, l.cyclePhaseMenstrualDescAlt),
    _PD(l.cyclePhaseFollicular, l.cyclePhaseFollicular, l.cyclePhaseFollicularDays, 8, kAmber, l.cycleHormoneFollicularLevel, 10.0, 0.0, l.cyclePhaseFollicularDescAlt),
    _PD(l.cyclePhaseOvulation, l.cyclePhaseOvulation, l.cyclePhaseOvulationDay, 1, kSage, l.cycleHormoneOvulationLevel, 14.0, 0.0, l.cyclePhaseOvulationDescAlt),
    _PD(l.cyclePhaseLuteal, l.cyclePhaseLuteal, l.cyclePhaseLutealDays, 14, kRoseDark, l.cycleHormoneLutealLevel, 22.0, 0.0, l.cyclePhaseLutealDescAlt),''',
    '''_P2(l.cyclePhaseMenstrual, l.cyclePhaseMenstrual, l.cyclePhaseMenstrualDays, 5, kRose, l.cycleHormoneMenstrualLevel, 3.0, 0.8, l.cyclePhaseMenstrualDescAlt),
    _P2(l.cyclePhaseFollicular, l.cyclePhaseFollicular, l.cyclePhaseFollicularDays, 8, kAmber, l.cycleHormoneFollicularLevel, 10.0, 0.0, l.cyclePhaseFollicularDescAlt),
    _P2(l.cyclePhaseOvulation, l.cyclePhaseOvulation, l.cyclePhaseOvulationDay, 1, kSage, l.cycleHormoneOvulationLevel, 14.0, 0.0, l.cyclePhaseOvulationDescAlt),
    _P2(l.cyclePhaseLuteal, l.cyclePhaseLuteal, l.cyclePhaseLutealDays, 14, kRoseDark, l.cycleHormoneLutealLevel, 22.0, 0.0, l.cyclePhaseLutealDescAlt),'''
)


with open('your_cycle_chapters.dart', 'w') as f:
    f.write(content)

