import re

with open('your_cycle_chapters.dart', 'r') as f:
    content = f.read()

# 1. Add Ch0SharedState and Ch0SidebarPanel at the end of the file
shared_classes = """
// ═══════════════════════════════════════════════════════════════════════════════
// SIDEBAR PANELS for LessonScreen
// ═══════════════════════════════════════════════════════════════════════════════
class Ch0SharedState extends ChangeNotifier {
  int autoPhase = 0;
  int selPhase = -1;
  double day = 0;
  double t = 0;

  void update(int ap, double d, double time) {
    if (autoPhase == ap && day == d && t == time) return;
    autoPhase = ap; day = d; t = time;
    notifyListeners();
  }

  void selectPhase(int p) {
    selPhase = p;
    notifyListeners();
  }
}
final ch0Shared = Ch0SharedState();

class Ch0SidebarPanel extends StatelessWidget {
  const Ch0SidebarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ch0Shared,
      builder: (context, _) {
        final state = ch0Shared;
        final phaseIdx = state.selPhase >= 0 ? state.selPhase : state.autoPhase;
        final pd = _Ch0State._phases[phaseIdx];

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: pd.color.withValues(alpha: 0.3), width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(color: pd.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    pd.name,
                    style: TextStyle(fontFamily: 'Fraunces', fontSize: 20, fontWeight: FontWeight.w800, color: pd.color),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pd.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      pd.days,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: pd.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                pd.description,
                style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF2A1A1F)),
              ),
              const SizedBox(height: 24),
              // Hormone Chart
              SizedBox(
                width: double.infinity, height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HORMONES', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: kInk60, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Expanded(child: CustomPaint(painter: _HormoneChart(day: state.day, t: state.t))),
                    const SizedBox(height: 4),
                    const Row(children: [
                      _Leg(kRose, 'Oestrogen'), SizedBox(width: 12),
                      _Leg(kSage, 'Prog.'), SizedBox(width: 12),
                      _Leg(kAmber, 'LH'),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Phase selector chips
              const Text('PHASES', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: kInk60, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(4, (i) {
                  final active = i == phaseIdx;
                  final p = _Ch0State._phases[i];
                  return GestureDetector(
                    onTap: () => ch0Shared.selectPhase(active ? -1 : i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? p.color : Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: active ? p.color : Colors.black12),
                        boxShadow: active ? [BoxShadow(color: p.color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                      ),
                      child: Text(
                        p.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                          color: active ? Colors.white : kInk60,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }
    );
  }
}
"""

content = content + "\n" + shared_classes

# 2. Update _Ch0State to sync with ch0Shared and remove _selPhase

sync_listener = """
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

content = re.sub(r'  @override\n  void initState\(\) \{\n    super.initState\(\);\n    _ctrl = AnimationController\(vsync: this, duration: const Duration\(seconds: 18\)\)\n      \.\.addListener\(\(\) => setState\(\(\) \{\}\)\)\n      \.\.repeat\(\);\n  \}', sync_listener, content)

content = content.replace("int _selPhase = 0;", "")
content = content.replace("final phase = _selPhase >= 0 ? _selPhase : _autoPhase;", "final phase = ch0Shared.selPhase >= 0 ? ch0Shared.selPhase : _autoPhase;")
content = content.replace("_selPhase = i", "ch0Shared.selectPhase(i)")

# 3. Remove _Ch0PhaseStrip usage
strip_usage = """        // ── 8. Bottom info strip
        _Ch0PhaseStrip(
          phase: phase, pd: pd,
          day: _day, t: _ctrl.value,
          phases: _phases, selPhase: _selPhase,
          onPhaseSelect: (i) => setState(() => _selPhase = i),
        ),"""

# Using regex to remove it safely because selPhase is now ch0Shared.selPhase
content = re.sub(r'\s*// ── 8\. Bottom info strip\s*_Ch0PhaseStrip\([^)]+\),', '', content)

# 4. Remove _Ch0PhaseStrip definition
content = re.sub(r'// ── Bottom phase info strip ───────────────────────────────────────────────────.*?class _PD', 'class _PD', content, flags=re.DOTALL)

with open('your_cycle_chapters.dart', 'w') as f:
    f.write(content)

