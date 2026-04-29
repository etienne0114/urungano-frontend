import re

with open('your_cycle_chapters.dart', 'r') as f:
    content = f.read()

# 1. _Ch0State: replace _selPhase with ch0Shared.selPhase, and use _getPhases
content = content.replace("int _selPhase = -1;", "")
content = content.replace("int _selPhase = 0;", "")
content = content.replace("final phase = _selPhase >= 0 ? _selPhase : _autoPhase;", "final phase = ch0Shared.selPhase >= 0 ? ch0Shared.selPhase : _autoPhase;")
content = content.replace("_phases[phase]", "_getPhases(AppLocalizations.of(context)!)[phase]")
content = content.replace("_selPhase = i", "ch0Shared.selectPhase(i)")

# 2. _Ch2State: _phases
content = content.replace("_phases[_sel]", "_getPhases(AppLocalizations.of(context)!)[_sel]")

# 3. Ch2 _ProPhaseStrip usage inside _Ch2State
# Wait, I removed _ProPhaseStrip entirely from _Ch2State when I did Ch2SidebarPanel previously!
strip_usage_ch2 = r"""      // Professional phase strip — right panel
      Positioned\(
        right: 10, top: 18, bottom: 12, width: 346,
        child: _ProPhaseStrip\(ph: ph, sel: _sel, t: _ctrl\.value\),
      \),"""
content = re.sub(strip_usage_ch2, '', content)

# 4. _Ch0PhaseStrip usage inside _Ch0State
# Remove _Ch0PhaseStrip call
content = re.sub(r'\s*// ── 8\. Bottom info strip\s*_Ch0PhaseStrip\([^)]+\),', '', content)
# Remove _Ch0PhaseStrip class
content = re.sub(r'// ── Bottom phase info strip ───────────────────────────────────────────────────.*?class _PD', 'class _PD', content, flags=re.DOTALL)

# 5. Fix _Ch0State listener
sync_ch0 = """
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 18))
      ..addListener(() {
        setState(() {});
        ch0Shared.update(_autoPhase, _day, _ctrl.value);
      })
      ..repeat();
  }
"""
content = re.sub(r'  @override\n  void initState\(\) \{\n    super.initState\(\);\n    _ctrl = AnimationController\(vsync: this, duration: const Duration\(seconds: 18\)\)\n      \.\.addListener\(\(\) => setState\(\(\) \{\}\)\)\n      \.\.repeat\(\);\n  \}', sync_ch0, content)

# 6. Fix _Ch2State listener
sync_ch2 = """
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..addListener(() {
        setState(() {});
        ch2Shared.update(_sel, _ctrl.value);
      })
      ..repeat();
  }
"""
content = re.sub(r'  @override\n  void initState\(\) \{\n    super.initState\(\);\n    _ctrl = AnimationController\(vsync: this, duration: const Duration\(seconds: 12\)\)\n      \.\.addListener\(\(\) => setState\(\(\) \{\}\)\)\.\.repeat\(\);\n  \}', sync_ch2, content)

with open('your_cycle_chapters.dart', 'w') as f:
    f.write(content)

