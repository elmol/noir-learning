# Day 2 — Claude Code Prompts

## Template

Each entry follows this format:

---

### Prompt

> Paste the exact prompt you gave Claude Code here.

### Result

What Claude Code produced or answered.

### Claude Code Insight

What this revealed about using Claude Code as a ZK/Noir assistant.

---

## Entries

---

### Prompt

> "What should the next line be, and why?" (after writing only the function signature)

### Result

Claude Code explained the constraint conceptually — what it needs to express, the
Poseidon2 API path, why `assert` is required instead of a bare expression — before
providing the exact line. The answer was structured as reasoning, not code generation.

### Claude Code Insight

Incremental pair programming works because each step forces an explanation. Asking
"what should the next line be and why" produces more understanding than "write the
function" even when the final code is identical.

---

### Prompt

> "Ultrathink: Why is Poseidon2 preferred over SHA256 in a ZK circuit? What are the tradeoffs? Don't write any code."

### Result

Claude Code gave a thorough tradeoff analysis covering constraint counts, SHA256's
bitwise simulation cost, Poseidon2's native field operations, security tradeoffs
(track record, algebraic attack surface), and interoperability. It also clarified
that `Ultrathink:` is not an official feature.

### Claude Code Insight

The prefix "don't write any code" is the real trigger — it forces reasoning mode.
Pseudo-commands like `Ultrathink:` and `/think` are not official Claude Code features.
Prompt structure (not magic keywords) controls the quality of the response.

---

### Prompt

> "Compare today's poseidon2_commitment circuit against Day 1's commitment_circuit. What changed, what's the same, and what's still missing before this is production-ready?"

### Result

Claude Code read both circuit files plus CLAUDE.md before answering. It identified:
same signature and test structure; changed constraint (Poseidon2 vs identity); missing
nonce, domain separation, nullifier, entropy enforcement, and Merkle integration.

### Claude Code Insight

Cross-file comparison questions are where Claude Code's tool use becomes visible.
It didn't answer from memory — it read both files, then synthesized. The answer was
grounded in actual code, not in what a "typical commitment circuit" might look like.

---

### Prompt

> "Draw an ASCII diagram of the full identity system we are building, showing where today's commitment circuit sits in the pipeline."

### Result

A full ASCII pipeline diagram showing prover/verifier split, today's Poseidon2 step,
the Merkle tree structure, Day 3's circuit signature, and the Rust backend. Included
what the proof guarantees and what it explicitly does NOT reveal.

### Claude Code Insight

Diagram prompts (Module 4) make abstract architecture concrete. Seeing the full system
in one view clarified that today's circuit is one `assert` inside the Day 3 circuit —
not a standalone deliverable.
