# 4-Day Learning Plan — Noir + Claude Code

## Overview

**Technical project:** Build a Noir circuit that proves Merkle tree membership using
Poseidon2 commitments, as part of a larger identity system:

```
secret
  └─► Poseidon2(secret) = commitment
        └─► Merkle leaf
              └─► Merkle tree construction
                    └─► membership proof circuit (Noir)
                          └─► Rust prover / verifier
```

**Two parallel learning tracks:**
1. **Noir track** — syntax, types, constraints, Poseidon2, Merkle trees, prove/verify
2. **Claude Code track** — using it as a real development agent: context awareness,
   incremental pair programming, code exploration, retrospectives

**Schedule:** 4 days × ~5 hours

**Key constraint:** Understand before generating. Every session prioritizes
explanation-first prompts over code-generation prompts. Metacognition checkpoints
are non-negotiable — if you can't explain it, you haven't learned it yet.

**Reference course:** [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action)

### Course Modules Map

| # | Module | Mapped to |
|---|--------|-----------|
| 1 | Coding Assistant Architecture | Day 1 |
| 2 | Claude Code's Tool Use System | Day 1 |
| 3 | Context Management Techniques | Day 1–2 |
| 4 | Visual Communication Workflows | Day 2 |
| 5 | Custom Automation | Day 3 |
| 6 | MCP Server Integration | Day 4 |
| 7 | GitHub Workflow Integration | Day 4 |
| 8 | Thinking and Planning Modes | Day 2–3 |

---

## Day 1 — Noir Foundations + Claude Code as Architectural Tool (~5h)

### Technical Goal
Stand up the dev environment, understand Noir's mental model (circuits ≠ programs),
and write a first circuit that compiles and passes `nargo test`.

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

### Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Environment | 0:00–0:30 | Install nargo, verify, explore docs |
| Concept | 0:30–1:30 | Study Noir mental model — circuits, witnesses, constraints |
| Coding | 1:30–3:00 | First two circuits, compile, test |
| Claude Code | 3:00–4:00 | Modules 1–3, practice explanation-first prompts |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md |

### Metacognition Checkpoint
Before closing the session, answer these in `NOTES.md` without looking things up:
1. What is a circuit? How is it different from a regular function?
2. What is a constraint? What does `assert(x == y)` actually mean in ZK?
3. What is a `Field` element? Why not just use `u64`?
4. What is the difference between a public and a private input?
5. What did Claude Code do that a ChatGPT tab would not have done?

---

## Day 2 — Poseidon2 Commitment + Context Management & Thinking Modes (~5h)

### Technical Goal
Build the commitment layer of the identity system: `commitment = Poseidon2(secret)`.
Understand why Poseidon2 is ZK-friendly. The output of this day is a working,
tested commitment circuit.

### Noir Milestones
- [ ] Use `std::hash::poseidon2::Poseidon2` to hash a field element
- [ ] Circuit: `fn main(secret: Field, commitment: pub Field)`
      with `assert(Poseidon2::hash([secret], 1) == commitment)`
- [ ] `nargo test` passes for commitment circuit
- [ ] Understand: why not SHA256? What makes a hash "circuit-friendly"?
- [ ] Optional: hash two inputs → `Poseidon2::hash([a, b], 2)`

### Claude Code Milestones
- [ ] **Module 8** — Use extended thinking mode for design questions.
      Prompt: "Think carefully: why is Poseidon2 preferred over SHA256 in a ZK circuit?
      What are the tradeoffs? Don't write code yet."
- [ ] **Module 3 (deep)** — Practice referencing project resources.
      Ask Claude Code to compare today's circuit against Day 1's and identify what changed.
- [ ] **Module 4** — Use a visual/diagram prompt to map the full identity system.
      Prompt: "Draw an ASCII diagram of the full identity system we are building."
- [ ] Practice the **incremental pair programming pattern**:
      Write one line, ask Claude Code to predict what the next constraint should be.

### Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Concept | 0:00–1:00 | Study Poseidon2: structure, ZK-friendliness, R1CS vs Plonkish |
| Coding | 1:00–2:30 | Commitment circuit: write, compile, test |
| Exploration | 2:30–3:30 | Claude Code Modules 8 + 3 deep; diagram prompt |
| Debugging | 3:30–4:00 | Intentionally break something; use Claude Code to diagnose |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md |

### Metacognition Checkpoint
1. What makes a hash function "ZK-friendly"? What would happen if you used SHA256?
2. What is a commitment scheme? Why does the prover hide `secret` but reveal `commitment`?
3. What is the `1` parameter in `Poseidon2::hash([secret], 1)`?
4. Where does this commitment fit in the full identity system diagram?
5. What did using extended thinking (Module 8) change about how Claude Code responded?

---

## Day 3 — Merkle Membership Proof Circuit + Custom Automation (~5h)

### Technical Goal
Build the core circuit of the project: prove that a commitment is a leaf in a
Merkle tree with a known root, without revealing which leaf.
Move the final circuit to `project/circuits/`.

### Architecture
```
fn main(
    secret:      Field,        // private: the secret
    commitment:  pub Field,    // public:  Poseidon2(secret)
    root:        pub Field,    // public:  Merkle root
    path:        [Field; N],   // private: sibling hashes along the path
    indices:     [u1; N],      // private: left/right decisions
)
```

### Noir Milestones
- [ ] Implement `fn hash_pair(left: Field, right: Field) -> Field` using Poseidon2
- [ ] Implement `fn compute_merkle_root(leaf, path, indices) -> Field`
      — loop over depth, conditionally swap left/right, hash pair
- [ ] Full main circuit: assert `commitment == Poseidon2(secret)` AND
      `root == compute_merkle_root(commitment, path, indices)`
- [ ] Write `nargo test` with a hand-computed 4-leaf Merkle tree
- [ ] Move to `project/circuits/`, run `nargo compile` + `nargo test` from there

### Claude Code Milestones
- [ ] **Module 5** — Create custom slash commands for nargo workflows:
      `/compile` → `nargo compile`, `/test` → `nargo test`, `/prove` → `nargo prove`
- [ ] **Module 8** — Use thinking mode for the loop + index logic.
      Prompt: "Think through the Merkle path loop. At each step, what are the
      two cases for indices[i]? Don't write code — explain the logic."
- [ ] Practice **code exploration** (not generation):
      Ask Claude Code to read the circuit and find all the constraints. Let it
      explain them back to you before you wrote them.
- [ ] **Retrospective mid-point**: ask Claude Code "What have we built so far?
      Summarize the project state from the files." — test its context awareness.

### Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Design | 0:00–0:45 | Whiteboard the Merkle path loop logic on paper |
| Coding | 0:45–2:30 | hash_pair → compute_merkle_root → main circuit |
| Testing | 2:30–3:15 | Hand-compute test vector, write nargo test, pass it |
| Claude Code | 3:15–4:00 | Module 5 automation + exploration prompts |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md, move to project/circuits/ |

### Metacognition Checkpoint
1. Explain the Merkle path loop iteration by iteration for a depth-3 tree.
2. Why do we need `indices`? What would break if we always put the new hash on the left?
3. Why does the circuit have both `commitment == Poseidon2(secret)` and the Merkle check?
4. What does the verifier learn from this proof? What does it not learn?
5. How did the custom automation (Module 5) change your workflow today?

---

## Day 4 — Rust Integration + GitHub Workflow + Full Retrospective (~5h)

### Technical Goal
Prove the Merkle membership circuit from Rust. Wire the full identity system:
Rust constructs the tree, generates inputs, calls the prover, and verifies the proof.

### Architecture
```
Rust:
  1. Generate secret (random Field element)
  2. Compute commitment = Poseidon2(secret)
  3. Build Merkle tree from a set of commitments
  4. Compute path + indices for our commitment
  5. Write Prover.toml
  6. Call `nargo prove` (subprocess) OR use noir_rs / barretenberg bindings
  7. Call `nargo verify` → assert success
```

### Rust Milestones
- [ ] Implement Poseidon2 in Rust (use `poseidon2` crate or manual impl for BN254)
- [ ] Implement a simple binary Merkle tree in Rust (HashMap or Vec-based)
- [ ] Generate `Prover.toml` programmatically from Rust structs
- [ ] Call `nargo prove` + `nargo verify` as subprocesses from Rust
- [ ] Full end-to-end test: random secret → proof → verified

### Claude Code Milestones
- [ ] **Module 6** — Use MCP to hold both Rust and Noir context simultaneously.
      Navigate between `project/circuits/` and the Rust crate without losing context.
- [ ] **Module 7** — Set up a GitHub Actions workflow:
      `nargo compile` + `nargo test` on every push to `project/circuits/`
- [ ] **Full retrospective** with Claude Code:
      Prompt: "Review all files in this repository. Give me a retrospective:
      what did we build, what are the weak points in the circuit, what would
      you refactor, and what should I study next?"
- [ ] Log the retrospective output verbatim in `LEARNINGS.md`

### Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Design | 0:00–0:45 | Map the Rust ↔ Noir interface (Field serialization, Prover.toml format) |
| Coding | 0:45–2:30 | Rust: Poseidon2, Merkle tree, Prover.toml generation |
| Integration | 2:30–3:30 | Wire subprocess calls, end-to-end test |
| Claude Code | 3:30–4:00 | Modules 6+7, GitHub Actions, retrospective prompt |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md + LEARNINGS.md |

### Metacognition Checkpoint
1. What is a witness? What is the difference between `nargo execute` and `nargo prove`?
2. How does Rust serialize a `Field` element to pass it to a Noir circuit?
3. What does UltraHonk give us over older proving systems?
4. What would change in the circuit if we wanted to prove membership of a different
   commitment scheme (e.g., Pedersen instead of Poseidon2)?
5. After the Claude Code retrospective, what do you now see as the weakest part of
   what you built?

---

## Learning Principles

These apply to every session:

### Explanation-First Prompts
Before asking Claude Code to write anything, ask it to explain.
- Bad: "Write a Merkle path verifier in Noir."
- Good: "Explain how Merkle path verification works. What are the inputs? What
  does each iteration of the loop compute? Once I understand, we'll write it together."

### Incremental Pair Programming
Never generate a complete function in one shot.
1. Ask Claude Code to outline the logic (no code).
2. You write the first 3 lines.
3. Ask Claude Code what the next line should be and why.
4. Repeat.

### Metacognition Checkpoints
Every session ends with the checkpoint questions answered in your own words in
`NOTES.md` — without looking at the code or asking Claude Code. If you can't
answer, the session isn't done.

### Prompt Logging
Every prompt that produces something interesting (good or bad) goes in
`claude-prompts.md` with the result and a one-line insight.

### Context Hygiene
Keep `CLAUDE.md` updated. After each day, add:
- What was built
- What files changed
- What the current status is

This is how Claude Code stays useful across sessions.
