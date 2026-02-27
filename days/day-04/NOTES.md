# Day 4 — Rust Integration + GitHub Workflow + Full Retrospective

## Goals

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

## Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Design | 0:00–0:45 | Map the Rust ↔ Noir interface (Field serialization, Prover.toml format) |
| Coding | 0:45–2:30 | Rust: Poseidon2, Merkle tree, Prover.toml generation |
| Integration | 2:30–3:30 | Wire subprocess calls, end-to-end test |
| Claude Code | 3:30–4:00 | Modules 6+7, GitHub Actions, retrospective prompt |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md + LEARNINGS.md |

## Metacognition Checkpoint

Answer these without looking things up:

1. What is a witness? What is the difference between `nargo execute` and `nargo prove`?
2. How does Rust serialize a `Field` element to pass it to a Noir circuit?
3. What does UltraHonk give us over older proving systems?
4. What would change in the circuit if we wanted to prove membership of a different
   commitment scheme (e.g., Pedersen instead of Poseidon2)?
5. After the Claude Code retrospective, what do you now see as the weakest part of
   what you built?

## What Worked

<!-- Fill in during / after the session -->

## What Didn't

<!-- Fill in during / after the session -->

## Key Learnings

<!-- Fill in during / after the session -->
