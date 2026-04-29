import re

with open('your_cycle_chapters.dart', 'r') as f:
    content = f.read()

# 1. Add Ch2SharedState and Ch2SidebarPanel at the end
shared_ch2 = """
class Ch2SharedState extends ChangeNotifier {
  int selPhase = 0;
  double t = 0;

  void update(int sel, double time) {
    if (selPhase == sel && t == time) return;
    selPhase = sel; t = time;
    notifyListeners();
  }

  void selectPhase(int p) {
    selPhase = p;
    notifyListeners();
  }
}
final ch2Shared = Ch2SharedState();

class Ch2SidebarPanel extends StatelessWidget {
  const Ch2SidebarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ch2Shared,
      builder: (context, _) {
        final ph = _Ch2State._phases[ch2Shared.selPhase];
        return _ProPhaseStrip(ph: ph, sel: ch2Shared.selPhase, t: ch2Shared.t);
      }
    );
  }
}
"""

content = content + "\n" + shared_ch2

# 2. Update _Ch2State to push to ch2Shared and use it
sync_listener = """
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

content = re.sub(r'  @override\n  void initState\(\) \{\n    super.initState\(\);\n    _ctrl = AnimationController\(vsync: this, duration: const Duration\(seconds: 12\)\)\n      \.\.addListener\(\(\) => setState\(\(\) \{\}\)\)\.\.repeat\(\);\n  \}', sync_listener, content)

# 3. Remove _ProPhaseStrip from the Stack in _Ch2State
strip_usage = r"""      // Professional phase strip — right panel
      Positioned\(
        right: 10, top: 18, bottom: 12, width: 346,
        child: _ProPhaseStrip\(ph: ph, sel: _sel, t: _ctrl\.value\),
      \),"""

content = re.sub(strip_usage, '', content)

with open('your_cycle_chapters.dart', 'w') as f:
    f.write(content)

