import re

with open('your_cycle_chapters.dart', 'r') as f:
    content = f.read()

# Fix const lists and widgets that now contain AppLocalizations
content = content.replace("const Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [", "Column(crossAxisAlignment: CrossAxisAlignment.start, children: [")
content = content.replace("Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [", "Column(crossAxisAlignment: CrossAxisAlignment.start, children: [")

# Any remaining "const Text(AppLocalizations"
content = content.replace("const Text(AppLocalizations", "Text(AppLocalizations")

# Fix line 2180 `const Column(children: [` containing `_LR`
content = content.replace("const Column(children: [\n            _LR('🩸'", "Column(children: [\n            _LR('🩸'")

with open('your_cycle_chapters.dart', 'w') as f:
    f.write(content)

