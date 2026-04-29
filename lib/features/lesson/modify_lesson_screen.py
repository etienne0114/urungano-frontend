import re

with open('lesson_screen.dart', 'r') as f:
    content = f.read()

# 1. Increase canvasH to 720
content = content.replace('const canvasW = 900.0, canvasH = 680.0;', 'const canvasW = 900.0, canvasH = 720.0;')
content = content.replace('const double canvasW = 900, canvasH = 680;', 'const double canvasW = 900, canvasH = 720;')

# 2. Inject sidebars in _WideChapterView
wide_injection = """                      // Narration text always shown (below hotspots if any)
                      const SizedBox(height: 8),
                      if (lesson.slug == 'your_cycle' && chapter.orderIndex == 0)
                        const Padding(padding: EdgeInsets.only(bottom: 16), child: Ch0SidebarPanel()),
                      if (lesson.slug == 'your_cycle' && chapter.orderIndex == 2)
                        const Padding(padding: EdgeInsets.only(bottom: 16), child: Ch2SidebarPanel()),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),"""

content = re.sub(r'                      // Narration text always shown \(below hotspots if any\)\n                      const SizedBox\(height: 8\),\n                      Container\(\n                        width: double.infinity,\n                        padding: const EdgeInsets.all\(24\),', wide_injection, content)

# 3. Inject sidebars in _NarrowChapterView
narrow_injection = """          if (lesson.slug == 'your_cycle' && chapter.orderIndex == 0)
            const Padding(padding: EdgeInsets.only(bottom: 16), child: Ch0SidebarPanel()),
          if (lesson.slug == 'your_cycle' && chapter.orderIndex == 2)
            const Padding(padding: EdgeInsets.only(bottom: 16), child: Ch2SidebarPanel()),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),"""

content = re.sub(r'          Container\(\n            width: double.infinity,\n            padding: const EdgeInsets.all\(20\),', narrow_injection, content)

with open('lesson_screen.dart', 'w') as f:
    f.write(content)

