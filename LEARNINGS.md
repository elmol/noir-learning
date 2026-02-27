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

## Day 2 — Poseidon2 Commitment + Thinking Modes

### ZK / Noir Concepts

- **Poseidon2 is ZK-friendly because it speaks the field's native language.** SHA256
  simulates bit operations over a prime field (~25,000 constraints). Poseidon2 uses `x^5`
  as its S-box — native field arithmetic — costing ~270 constraints. Both proof generation
  and verification pay this cost, so the 100× difference matters on both sides.

- **Commitment schemes require two properties, not one.** Hiding (commitment doesn't
  reveal secret) is the obvious one. Binding (prover can't find two secrets with the same
  commitment) is equally fundamental. A scheme that is hiding but not binding lets the
  prover cheat after the fact.

- **An unconstrained public input is a security hole.** Removing `assert` from a circuit
  makes it accept any witness. Noir warns about this with "unused variable" — treat that
  warning as a security signal, not a style issue.

- **Production commitments need more than `Poseidon2(secret)`.** Missing pieces:
  nonce (prevents same commitment appearing twice), domain separation (prevents collision
  between commitment hashes and Merkle node hashes), nullifier (prevents replay).

- **The external Poseidon library is required in nargo 1.0.0-beta.5.** The stdlib path
  `std::hash::poseidon2` is not available. Use:
  `poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }`
  and import as `use poseidon::poseidon2;`.

### Claude Code Workflow

- **Extended thinking mode is not a conversational trigger.** `/think`, `Ultrathink:`,
  and "think carefully" do not activate a special mode. Extended thinking is an API-level
  parameter. The practical equivalent: structure prompts to demand reasoning before code
  ("explain the tradeoffs, don't write any code yet").

- **Module 3 deep = Claude Code reads before it speaks.** When asked to compare two
  circuits, it read both files plus CLAUDE.md before answering. The comparison was
  grounded in actual file content, not inference.

- **ASCII diagrams (Module 4) make architecture concrete.** Seeing the full pipeline in
  one view clarified exactly where today's circuit sits and what it does not yet prove.

## Day 3 — Merkle Membership Proof Circuit + Custom Automation

### ZK / Noir Concepts

- **The Merkle path loop needs `indices` to be correct.** At each step, the index
  determines whether the current node is the left or right child. Without it, the
  computed root is wrong for any right-child leaf — proofs fail for half the tree.

- **Both circuit constraints are necessary and non-redundant.**
  `assert(commitment == Poseidon2(secret))` proves secret ownership.
  `assert(root == compute_merkle_root(...))` proves tree membership.
  Either one alone is exploitable: the first without the second proves you know a secret
  but not that it's registered; the second without the first lets anyone claim membership
  for any commitment without knowing its secret.

- **`u1` is a security constraint, not just a type.** Using `[u1; N]` for indices
  enforces binary values (0 or 1 only) via range constraints. An unconstrained index
  type could allow malformed paths.

- **The linkability problem.** Reusing the same commitment as a public input across
  multiple proofs allows an observer to correlate those proofs to the same identity —
  without ever learning the secret. Solution: nullifiers (`Poseidon2(secret, context)`),
  which produce a unique unlinkable value per action.

- **The `message_size` parameter in Poseidon2.** The second argument to
  `Poseidon2::hash(inputs, n)` is the number of input elements to process, not the
  output length. The function always returns a single `Field`. Corrects the Day 2
  explanation which incorrectly called it "output length."

### Claude Code Workflow

- **Code exploration > code generation for security-critical circuits.** Asking Claude
  Code to "find all constraints and explain what attack each one prevents" is more
  valuable than asking it to write the circuit. The audit surfaces assumptions you
  might not have thought to check.

- **Custom slash commands require a session restart.** Files in `.claude/commands/`
  are loaded at startup. Create them, restart, and they appear in the slash menu.

- **Retrospective prompts test real context awareness.** "What have we built so far?"
  forces Claude Code to read files rather than infer from conversation. The answer is
  only as accurate as the files — which is why updating CLAUDE.md every day matters.

<!-- Day 4 learnings will go here -->
