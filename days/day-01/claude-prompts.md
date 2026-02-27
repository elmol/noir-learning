# Day 1 — Claude Code Prompts

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

> "What does this project do? Walk me through each circuit we built today and explain what it proves."

### Result

Claude Code fired three `Read` calls in parallel before answering:
- `days/day-01/hello_circuit/src/main.nr`
- `days/day-01/commitment_circuit/src/main.nr`
- `CLAUDE.md`

It then explained both circuits in the context of the full identity system pipeline
(from `CLAUDE.md`), showing exactly where each circuit fits and what it still lacks
(commitment_circuit has the right shape but the wrong hash — Poseidon2 comes Day 2).

### Claude Code Insight

Claude Code doesn't answer from memory. It reads. One question triggered three parallel
file reads before a single word of response. This is why `CLAUDE.md` matters — it's one
of those reads, and it gives the project context that makes the answer specific instead
of generic.

---

### Prompt

> "could review if the files are correctly synchronized with all what we did in day 1? if ok, commit and push otherwise synchronize with what we did"

### Result

Claude Code read all four tracking files (NOTES.md, LEARNINGS.md, claude-prompts.md,
CLAUDE.md), identified four gaps (unchecked milestones, missing metacognition answers,
empty LEARNINGS.md, empty prompt log), and fixed all of them before committing.

### Claude Code Insight

Asking Claude Code to "review and synchronize" works well when the files have clear
structure (checkboxes, placeholders). It can diff what exists against what should exist.
The key is that you review the proposed changes before they're committed — don't
auto-accept file edits without reading them.
