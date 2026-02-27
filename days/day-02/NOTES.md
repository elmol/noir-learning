# Day 2 — Poseidon2 Commitment + Context Management & Thinking Modes

## Goals

### Noir Milestones
- [x] Use `std::hash::poseidon2::Poseidon2` to hash a field element
- [x] Circuit: `fn main(secret: Field, commitment: pub Field)`
      with `assert(Poseidon2::hash([secret], 1) == commitment)`
- [x] `nargo test` passes for commitment circuit
- [x] Understand: why not SHA256? What makes a hash "circuit-friendly"?
- [ ] Optional: hash two inputs → `Poseidon2::hash([a, b], 2)`

### Claude Code Milestones
- [x] **Module 8** — Extended thinking mode explored; discovered `/think` and `Ultrathink:`
      are not official Claude Code features. Correct approach: explicit prompt structure
      ("explain tradeoffs, don't write code yet") forces reasoning before generation.
- [x] **Module 3 (deep)** — Claude Code read both Day 1 and Day 2 circuits before comparing.
      Confirmed tool use is real: it reads files, it doesn't guess.
- [x] **Module 4** — ASCII diagram of the full identity system drawn, showing exactly
      where today's commitment circuit sits and what Day 3 adds.
- [x] Practice the **incremental pair programming pattern**:
      Wrote the function signature, asked "what should the next line be and why?"

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

1. **What makes a hash function "ZK-friendly"? What would happen if you used SHA256?**
   ZK-friendly means compatible with prime field arithmetic, which reduces constraint cost.
   SHA256 requires many constraints to simulate bitwise operations over a prime field.
   The cost is higher for both proof generation and verification — roughly 100× more
   constraints than Poseidon2.

2. **What is a commitment scheme? Why does the prover hide `secret` but reveal `commitment`?**
   A commitment scheme lets someone prove they know a secret without revealing it.
   It has two properties: hiding (given the commitment, no one can recover the secret)
   and binding (the prover cannot find two different secrets with the same commitment).
   Note: initially forgot the binding property — it is as fundamental as hiding.

3. **What is the `1` parameter in `Poseidon2::hash([secret], 1)`?**
   The number of output field elements to squeeze from the sponge. `1` means return
   one field element as the hash output.

4. **Where does this commitment fit in the full identity system diagram?**
   It is the first step: proving that the prover knows the secret behind a commitment.
   It does NOT yet prove that the commitment belongs to a registered set of identities.
   That requires the Merkle membership proof (Day 3).

5. **What did the Option C debugging exercise reveal about ZK circuit security?**
   Removing the `assert` made the circuit accept any commitment for any secret — a
   completely malicious witness passed without error. The `#[test(should_fail)]` negative
   test was the only mechanism that caught it. An unconstrained public input is always
   a potential security hole; Noir even warns about it with "unused variable".

## What Worked

The explanation of commitment properties (hiding and binding) and ZK constraints was
clear and well-structured. Understanding what could go wrong in production — missing
nonce, no domain separation, no nullifier — gave real context for why the circuit is
only a starting point.

## What Didn't

The Poseidon2 import path suggested during the session was incorrect for the current
version of Noir. Resolving it required independent research outside the session. Also,
the guidance on Claude Code's extended thinking mode was inaccurate — `/think` and
`Ultrathink:` are not official features.

## Key Learnings

- Extended thinking mode does not work via slash commands or prefix keywords. The correct
  approach is to explicitly ask Claude Code for detailed reasoning in the prompt itself
  ("explain the tradeoffs, don't write code yet").
- The binding property of a commitment scheme is as fundamental as hiding — both must
  hold for the scheme to be secure. Easy to overlook.
- Noir's "unused variable" compiler warning is a security signal: an unconstrained public
  input means any witness value is accepted for that input.
- A circuit with no `assert` statements compiles and runs — it just proves nothing.
