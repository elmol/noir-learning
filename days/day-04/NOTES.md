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

- The full end-to-end pipeline ran successfully on the first attempt after fixing the Prover.toml
  format: `cargo run` → writes Prover.toml → `nargo execute` → `bb write_vk` → `bb prove` →
  `bb verify` → "Proof verified!"
- Extracting correct Poseidon2 hash values from Noir's own test runner (`nargo test --show-output`
  with `std::println`) was the key breakthrough that unblocked the integration.
- GitHub Actions CI workflow compiles and tests the circuit on every push to `project/circuits/`,
  with a pinned nargo version (`1.0.0-beta.18`).
- The retrospective prompt produced a precise audit of circuit weaknesses — more useful than
  asking Claude Code to write code.

## What Didn't

- `light-poseidon` (Rust crate) is incompatible with Noir's Poseidon2. It implements the original
  Poseidon hash function (Circom parameters), not Poseidon2. Hash values for the same inputs are
  completely different. There is currently no Poseidon2 Rust crate that matches Noir's output.
- `nargo prove` and `nargo verify` no longer exist in nargo 1.0.0-beta.18. The pipeline changed:
  `nargo execute` produces the witness, and `bb` (Barretenberg, a separate tool) handles
  proof generation and verification.
- The Rust prover ended up as a thin orchestrator with hardcoded hash values — not a real
  native prover. `bb` is not designed to be used as a Rust library, which limits how much
  can be done natively on the Rust side.
- The TOML format for Prover.toml required flat structure with all values as quoted strings;
  an `[inputs]` section header and unquoted values both caused parse errors.

## Key Learnings

- **Witness = all wire values; execute ≠ prove.** `nargo execute` solves the circuit for given
  inputs and produces the complete witness (all wire values, from inputs through internal steps).
  `bb prove` then takes that witness and generates a cryptographic proof for the verifier.
  These are two separate stages with two separate tools.

- **Poseidon ≠ Poseidon2.** Original Poseidon (Circom) and Poseidon2 (Noir) are different
  constructions with different round constants and S-box application. The name similarity is
  misleading. Always verify which variant a library implements before relying on hash value
  compatibility across languages.

- **`nargo test --show-output` is a debugging primitive.** When interoperability hashes don't
  match, print the expected values from inside the circuit using `std::println` in a debug test
  and run with `--show-output`. This is faster than reverse-engineering external library
  parameters.

- **CI protects compilation and test correctness, not security.** The GitHub Actions workflow
  catches broken tests and compile errors with a pinned nargo version. It cannot verify that
  the circuit is secure, that constraints are sufficient, or that the proving system is
  configured correctly.

- **The circuit has real weak points.** Hardcoded depth (2), no domain separation between
  commitment and node hashes, no nullifier for unlinkability, and a blinding-free commitment
  that is vulnerable to brute-force if the secret has low entropy. These are known gaps —
  not unknowns — which means the retrospective did its job.

- **`bb` is not a Rust-embeddable library.** Integrating native prove/verify into a Rust
  application requires either `noir_js` (TypeScript/browser) or waiting for Rust bindings
  to stabilize. Shelling out to external binaries is the current practical path, but it is
  fragile and not production-ready.
