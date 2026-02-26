# Noir + Claude Code: 4-Day Learning Journey

**Technical project:** Build a Noir circuit that proves Merkle tree membership using Poseidon2 commitments — part of a larger identity system (secret → commitment → Merkle tree → Rust prover).

## Progress Table

| Day | Noir Topic | Claude Code Modules | Status |
|-----|-----------|---------------------|--------|
| 1 | Fields, circuits, constraints, `nargo` basics | 1 · Coding Asst Architecture, 2 · Tool Use, 3 · Context Mgmt | [ ] Pending |
| 2 | Poseidon2 hashing, commitment circuit | 3 · Context Mgmt (deep), 4 · Visual Communication, 8 · Thinking Modes | [ ] Pending |
| 3 | Merkle tree membership proof circuit | 5 · Custom Automation, 8 · Thinking Modes | [ ] Pending |
| 4 | Rust prover integration, end-to-end | 6 · MCP Integration, 7 · GitHub Workflow | [ ] Pending |

## Repository Structure

```
.
├── CLAUDE.md              # Context file for Claude Code
├── LEARNINGS.md           # Consolidated learnings (filled during 4 days)
├── PLAN.md                # Full 4-day learning plan with milestones and schedule
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
