# Noir + Claude Code: 4-Day Learning Journey

**Technical goal:** Build a Noir circuit that proves membership in a Merkle tree using Poseidon2 commitments — part of a larger identity system with Rust.

## Progress Table

| Day | Noir Topic | Claude Code Topic | Status |
|-----|-----------|-------------------|--------|
| 1 | Noir basics: fields, circuits, constraints | Claude Code as a coding assistant | [ ] Pending |
| 2 | Hashing with Poseidon2 | Prompt engineering for ZK | [ ] Pending |
| 3 | Merkle tree membership proof | Code generation + iteration | [ ] Pending |
| 4 | Rust integration via `noir_rs` / UltraHonk | End-to-end workflow automation | [ ] Pending |

## Repository Structure

```
.
├── CLAUDE.md              # Context file for Claude Code
├── LEARNINGS.md           # Consolidated learnings (filled during 4 days)
├── README.md              # This file
├── days/
│   ├── day-01/
│   │   ├── NOTES.md           # Session notes
│   │   └── claude-prompts.md  # Prompts used with Claude Code
│   ├── day-02/
│   ├── day-03/
│   └── day-04/
└── project/
    └── circuits/          # The real Noir circuit lives here
```

## Stack

- [Noir](https://noir-lang.org/) — ZK circuit DSL
- [nargo](https://noir-lang.org/docs/nargo/installation) — Noir's package manager and prover CLI
- Rust — backend integration (proof verification, identity system)
