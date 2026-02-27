# Day 2 — Poseidon2 Commitment + Context Management & Thinking Modes

## Goals

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

## Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Concept | 0:00–1:00 | Study Poseidon2: structure, ZK-friendliness, R1CS vs Plonkish |
| Coding | 1:00–2:30 | Commitment circuit: write, compile, test |
| Exploration | 2:30–3:30 | Claude Code Modules 8 + 3 deep; diagram prompt |
| Debugging | 3:30–4:00 | Intentionally break something; use Claude Code to diagnose |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md |

## Metacognition Checkpoint

Answer these without looking things up:

1. What makes a hash function "ZK-friendly"? What would happen if you used SHA256?
2. What is a commitment scheme? Why does the prover hide `secret` but reveal `commitment`?
3. What is the `1` parameter in `Poseidon2::hash([secret], 1)`?
4. Where does this commitment fit in the full identity system diagram?
5. What did using extended thinking (Module 8) change about how Claude Code responded?

## What Worked

<!-- Fill in during / after the session -->

## What Didn't

<!-- Fill in during / after the session -->

## Key Learnings

<!-- Fill in during / after the session -->
