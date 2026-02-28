# CLAUDE.md — Context for Claude Code

This file gives Claude Code the context it needs to assist effectively throughout this project.

## Project Goal

Build a Noir circuit that proves Merkle tree membership using **Poseidon2 commitments**,
as part of a larger identity system. The full pipeline:

```
secret
  └─► Poseidon2(secret) = commitment
        └─► Merkle leaf
              └─► Merkle tree construction
                    └─► membership proof circuit (Noir)
                          └─► Rust prover / verifier
```

**Learning constraint:** Understanding before generating. Explanation-first prompts,
incremental pair programming, metacognition checkpoints at the end of every session.
See `PLAN.md` for the full plan.

## Stack

| Tool | Role |
|------|------|
| [Noir](https://noir-lang.org/) | ZK circuit DSL (`.nr` files) |
| [nargo](https://noir-lang.org/docs/nargo/installation) v1.0.0-beta.18 | Compile + execute circuits (witness generation) |
| [bb](https://github.com/AztecProtocol/aztec-packages) v0.72.1 | Barretenberg: prove + verify (separate from nargo) |
| Rust | Backend: proof generation/verification, identity logic |

## Repository Structure

```
.
├── CLAUDE.md              ← you are here
├── LEARNINGS.md           ← consolidated learnings across 4 days
├── README.md              ← project overview + progress table
├── days/
│   ├── day-01/            ← Noir basics + Claude Code as assistant
│   ├── day-02/            ← Poseidon2 hashing
│   ├── day-03/            ← Merkle tree membership proof
│   └── day-04/            ← Rust integration
└── project/
    └── circuits/          ← the real circuit lives here
```

Each `days/day-XX/` contains:
- `NOTES.md` — goals, what worked, what didn't, key learnings
- `claude-prompts.md` — prompts used, results, Claude Code insights

## Current Status

- [x] Day 1: Noir basics + dev environment working
  - `days/day-01/hello_circuit` — initial learning circuit (Field equality, positive + negative tests)
  - `days/day-01/commitment_circuit` — commitment concept circuit (secret/commitment placeholder; Poseidon2 comes Day 2)
- [x] Day 2: Poseidon2 hash circuit compiling with nargo
  - `days/day-02/poseidon2_commitment` — real Poseidon2 commitment circuit (external lib: poseidon v0.1.1)
  - Stdlib path `std::hash::poseidon2` unavailable in current nargo version; use external crate instead
- [x] Day 3: Merkle membership proof circuit passing tests
  - `days/day-03/merkle_membership` — full membership proof (hash_pair + compute_merkle_root + both constraints)
  - `project/circuits/` — final circuit copied here
  - Custom slash commands: `.claude/commands/` (nargo-test, nargo-compile, nargo-prove)
- [ ] Day 4: Rust integration proving/verifying end-to-end

## Prove/Verify Workflow (nargo 1.0.0-beta.18 + bb 0.72.1)

`nargo prove` and `nargo verify` are REMOVED. Use this pipeline:

```bash
# 1. Compile circuit → target/<name>.json  (ACIR)
nargo compile

# 2. Write Prover.toml with inputs (decimal strings for Field elements)
# secret = "1"
# path = ["2", "3"]
# indices = ["0", "0"]
# commitment = "<Poseidon2(secret) as decimal>"
# root = "<Merkle root as decimal>"

# 3. Execute circuit → target/<name>.gz  (witness)
nargo execute

# 4. Generate verification key → target/vk
bb write_vk -b target/<name>.json -o target/

# 5. Generate proof → target/proof
bb prove -b target/<name>.json -w target/<name>.gz -o target/

# 6. Verify proof (exit 0 = valid)
bb verify -k target/vk -p target/proof
```

## Other Frequent nargo Commands

```bash
nargo new <project_name>   # Create a new Noir project
nargo compile              # Compile to ACIR
nargo execute              # Compute witness (reads Prover.toml)
nargo test                 # Run circuit tests
nargo --version            # Check version
```

## Notes for Claude Code

- Noir uses a Rust-like syntax but is NOT Rust. Field arithmetic is implicit.
- The main entry point of a circuit is `fn main(...)`.
- `pub` parameters are public inputs (revealed to the verifier).
- Private inputs have no visibility modifier.
- Poseidon2 is available via `noir_stdlib` or external crates.
- Merkle proofs require hash-path + sibling nodes, not the full tree.
