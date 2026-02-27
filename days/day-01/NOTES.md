# Day 1 — Noir Foundations + Claude Code as Architectural Tool

## Goals

### Noir Milestones
- [x] Install nargo, run `nargo --version`
- [x] `nargo new hello_circuit` — inspect the generated structure
- [x] Understand `Field` vs integers; `pub` vs private inputs
- [x] Write `fn main(x: Field, y: pub Field) { assert(x == y); }`
- [x] Run `nargo compile` and `nargo test`
- [x] Write a second circuit: `fn main(secret: Field, commitment: pub Field)`
      where commitment is just `secret` for now (Poseidon2 comes Day 2)

### Claude Code Milestones
- [x] **Module 1** — Understand how Claude Code uses tools under the hood
      (Read, Grep, Bash). Ask it to explain a Noir file it just read.
- [x] **Module 2** — Watch it use multiple tools for one question.
      Prompt: "What does this circuit do? Walk me through each line."
- [x] **Module 3** — Set up `CLAUDE.md` as living context.
      Test: close and reopen session, ask "what is this project?" — it should answer correctly.
- [x] Practice the **explanation-first pattern**:
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

1. **What is a circuit? How is it different from a regular function?**
   A circuit is a mathematical system that uses an array of equations to prove if the
   constraints are met or not: `c(x,y) → true/false`. A regular function is `f(x) → y`
   which produces a result. The circuit doesn't compute — it checks.

2. **What is a constraint? What does `assert(x == y)` actually mean in ZK?**
   A constraint is a restriction/equation that must be met. `assert(x == y)` means the
   proof system will enforce that x equals y as a polynomial equation. If the constraint
   is not satisfied, the proof cannot be generated (there is no runtime crash — the math
   just doesn't work out).

3. **What is a `Field` element? Why not just use `u64`?**
   A Field element is an integer in a prime field (BN254, ~254 bits) used natively by
   the proof system. We can't just use `u64` because u64 has wraparound semantics at 2^64
   that the Field doesn't naturally enforce — Noir has to add explicit range-check
   constraints to simulate u64 behavior, which costs extra gates.

4. **What is the difference between a public and a private input?**
   Public: visible to both prover and verifier. Private: known only to the prover.
   The power of ZK is that the verifier is convinced the constraint holds without ever
   seeing the private input.

5. **What did Claude Code do that a ChatGPT tab would not have done?**
   Claude Code has access to tools (Read, Grep, Bash) so it actually reads the project
   files before answering — it builds understanding from what exists, not from memory.
   It also uses CLAUDE.md to carry project context across sessions, something a stateless
   chat tab cannot do.

## What Worked

It was really helpful to review the foundational concepts—zk proofs, field elements, the proving system, and so on.

Going over the negative‑test cases also clarified how the circuits behave when the inputs are wrong.

## What Didn't

It took me a while to answer some of the checkpoint questions even though they seemed simple – the review was necessary to make the concepts stick, but it slowed the session a bit.



## Key Learnings

It was incredible to see Claude Code guide me through a structured training—proof that an AI assistant can orchestrate a learning session step by step.  Reviewing circuits, Fields, public vs private inputs, and keeping context in CLAUDE.md really solidified my understanding.

