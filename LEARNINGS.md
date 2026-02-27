# Learnings

Consolidated insights from the 4-day Noir + Claude Code learning journey.
This file is filled progressively — one entry per day.

---

## Day 1 — Noir Foundations + Claude Code as Architectural Tool

### ZK / Noir Concepts

- **`assert` is a constraint, not a runtime check.** In Python, `assert` crashes if false.
  In Noir, `assert` means "add a polynomial equation to the circuit." If unsatisfied,
  the proof cannot be generated — no crash, no output, just no valid proof.

- **`Field` is the native type; `u64` costs extra.** The BN254 field is ~254 bits.
  Using `u64` forces Noir to add range-check constraints (0..2^64-1) because the field
  has no natural wraparound at 2^64. `Field` operations are free — they're native to the
  proof system.

- **Circuits define relationships, not computations.** `f(x) → y` vs `c(x,y) → true/false`.
  The prover finds a witness; the verifier checks the proof. The circuit is the set of rules.

- **`#[test(should_fail)]` is essential in ZK.** A passing positive test only proves
  satisfiability for that witness. A negative test proves the constraint actually rejects
  bad inputs. Always write both.

- **Commitment placeholder pattern.** Day 1 commitment circuit uses `assert(secret == commitment)`
  as a structural placeholder. It has the right shape (private secret, public commitment)
  but the wrong binding. Day 2 replaces it with `Poseidon2(secret) == commitment`.

### Claude Code Workflow

- **Claude Code reads files — it doesn't guess.** Every answer is built from actual tool
  calls (Read, Grep, Glob, Bash). Prompt with file paths and specific context; avoid
  vague prompts that force inference.

- **CLAUDE.md is cross-session memory.** Claude Code starts cold each session. Updating
  CLAUDE.md at the end of every day is what makes it project-aware next time.

- **Explanation-first pattern.** Ask Claude Code to explain before writing any code.
  In ZK especially, generated code that compiles can still be logically wrong — and the
  proof system won't catch it if the constraints are incomplete.

- **Dictate content, delegate mechanics.** When asking Claude Code to update files,
  provide the substance yourself. Let it handle the editing. The content should reflect
  your understanding, not its inference.

<!-- Day 2 learnings will go here -->

<!-- Day 3 learnings will go here -->

<!-- Day 4 learnings will go here -->
