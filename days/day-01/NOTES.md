# Day 1 — Noir Foundations + Claude Code as Architectural Tool

## Goals

### Noir Milestones
- [ ] Install nargo, run `nargo --version`
- [ ] `nargo new hello_circuit` — inspect the generated structure
- [ ] Understand `Field` vs integers; `pub` vs private inputs
- [ ] Write `fn main(x: Field, y: pub Field) { assert(x == y); }`
- [ ] Run `nargo compile` and `nargo test`
- [ ] Write a second circuit: `fn main(secret: Field, commitment: pub Field)`
      where commitment is just `secret` for now (Poseidon2 comes Day 2)

### Claude Code Milestones
- [ ] **Module 1** — Understand how Claude Code uses tools under the hood
      (Read, Grep, Bash). Ask it to explain a Noir file it just read.
- [ ] **Module 2** — Watch it use multiple tools for one question.
      Prompt: "What does this circuit do? Walk me through each line."
- [ ] **Module 3** — Set up `CLAUDE.md` as living context.
      Test: close and reopen session, ask "what is this project?" — it should answer correctly.
- [ ] Practice the **explanation-first pattern**:
      "Explain what a Field element is in Noir before writing any code."

## Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Environment | 0:00–0:30 | Install nargo, verify, explore docs |
| Concept | 0:30–1:30 | Study Noir mental model — circuits, witnesses, constraints |
| Coding | 1:30–3:00 | First two circuits, compile, test |
| Claude Code | 3:00–4:00 | Modules 1–3, practice explanation-first prompts |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md |

## Metacognition Checkpoint

Answer these without looking things up:

1. What is a circuit? How is it different from a regular function?
2. What is a constraint? What does `assert(x == y)` actually mean in ZK?
3. What is a `Field` element? Why not just use `u64`?
4. What is the difference between a public and a private input?
5. What did Claude Code do that a ChatGPT tab would not have done?

## What Worked

<!-- Fill in during / after the session -->

## What Didn't

<!-- Fill in during / after the session -->

## Key Learnings

<!-- Fill in during / after the session -->
