# Day 3 — Merkle Membership Proof Circuit + Custom Automation

## Goals

### Circuit Architecture

```noir
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
      explain them back to you before you write them.
- [ ] **Retrospective mid-point**: ask Claude Code "What have we built so far?
      Summarize the project state from the files." — test its context awareness.

## Session Schedule (~5h)

| Block | Time | Activity |
|-------|------|----------|
| Design | 0:00–0:45 | Whiteboard the Merkle path loop logic on paper |
| Coding | 0:45–2:30 | hash_pair → compute_merkle_root → main circuit |
| Testing | 2:30–3:15 | Hand-compute test vector, write nargo test, pass it |
| Claude Code | 3:15–4:00 | Module 5 automation + exploration prompts |
| Metacognition | 4:00–4:30 | Checkpoint (see below) |
| Log | 4:30–5:00 | Fill NOTES.md + claude-prompts.md, move to project/circuits/ |

## Metacognition Checkpoint

Answer these without looking things up:

1. Explain the Merkle path loop iteration by iteration for a depth-3 tree.
2. Why do we need `indices`? What would break if we always put the new hash on the left?
3. Why does the circuit have both `commitment == Poseidon2(secret)` and the Merkle check?
4. What does the verifier learn from this proof? What does it not learn?
5. How did the custom automation (Module 5) change your workflow today?

## What Worked

<!-- Fill in during / after the session -->

## What Didn't

<!-- Fill in during / after the session -->

## Key Learnings

<!-- Fill in during / after the session -->
