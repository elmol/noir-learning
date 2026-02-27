# Day 3 — Claude Code Prompts

## Template

Each entry follows this format:

---

### Prompt

> Paste the exact prompt you gave Claude Code here.

### Result

What Claude Code produced or answered.

### Claude Code Insight

What this revealed about using Claude Code as a ZK/Noir assistant.

---

## Entries

---

### Prompt

> "Read the merkle_membership circuit and find all the constraints. Explain each one — what it enforces and what attack would be possible if it were removed."

### Result

Claude Code read the circuit and identified 2 explicit constraints + 1 implicit (`u1` type).
For each: what it enforces, the exact attack if removed, and how the two asserts form a
security chain: secret → commitment → Merkle root. Removing either link breaks the proof.

### Claude Code Insight

Code exploration prompts ("find all constraints and explain them") produce better security
understanding than code generation prompts. Claude Code audited code it didn't write and
correctly identified the linkage between the two asserts as the core security property.

---

### Prompt

> "What have we built so far? Summarize the project state from the files."

### Result

Claude Code read CLAUDE.md, LEARNINGS.md, and ran a Glob to find all circuits before
answering. It gave an accurate project state: 4 circuits, 2 complete days, Day 3 in
progress, project/circuits/ still empty. Also identified 3 weak points from the files:
hardcoded depth, no domain separation, final circuit not yet moved.

### Claude Code Insight

The retrospective prompt tests cross-file context awareness. Claude Code didn't summarize
from memory — it read the actual status files and synthesized from what exists. The
"what's still missing" section came from reading the files, not guessing.
