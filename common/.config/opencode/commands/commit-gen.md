---
description:
  Generates organized git add && git commit commands based on repo history
agent: plan
---

Run `git log -10` to inspect the commit convention and check current changes.
Then generate ready-to-run `git add && git commit` commands:

- Group changes by cohesive, complete features rather than per file.
- Do NOT split changes into hunks (stage whole files, no partial staging).
- Match the commit style from `git log -10`.
- No overthinking, analysis, or explanations—keep it a fast one-shot.
- Output a single copy-pasteable bash block.
