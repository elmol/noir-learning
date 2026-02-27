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
- [x] Implement `fn hash_pair(left: Field, right: Field) -> Field` using Poseidon2
- [x] Implement `fn compute_merkle_root(leaf, path, indices) -> Field`
      — loop over depth, conditionally swap left/right, hash pair
- [x] Full main circuit: assert `commitment == Poseidon2(secret)` AND
      `root == compute_merkle_root(commitment, path, indices)`
- [x] Write `nargo test` with a hand-computed 4-leaf Merkle tree
- [x] Move to `project/circuits/`, run `nargo compile` + `nargo test` from there

### Claude Code Milestones
- [x] **Module 5** — Created custom slash commands: `/nargo-test`, `/nargo-compile`,
      `/nargo-prove` in `.claude/commands/`. Requires session restart to take effect.
- [x] **Module 8** — Explained the two loop cases before writing code:
      index=0 → hash(current, sibling), index=1 → hash(sibling, current).
- [x] Practice **code exploration** (not generation):
      Asked Claude Code to audit all constraints and explain what attack each one prevents.
- [x] **Retrospective mid-point**: Claude Code read CLAUDE.md + LEARNINGS.md + all circuits
      and gave an accurate project state summary from files.

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

1. **Explain the Merkle path loop for a 4-leaf tree proving leaf L0.**
   Step 0: current=L0 (commitment), sibling=L1, index=0 (L0 is left)
   → new current = hash(L0, L1) = h01.
   Step 1: current=h01, sibling=h23, index=0 (h01 is left)
   → new current = hash(h01, h23) = root. Assert root == known root.

2. **Why do we need `indices`?**
   The index determines whether the current node is the left or right child.
   If we always put current on the left, the computed root would be wrong for any
   right-child leaf (index=1). Proofs would fail for half the leaves in the tree.

3. **Why does the circuit need both constraints?**
   The first constraint (`commitment == Poseidon2(secret)`) proves you own the secret
   behind the commitment. The second (`root == compute_merkle_root(...)`) proves the
   commitment is in the tree. Without the first, anyone can claim membership for any
   commitment without knowing its secret. Without the second, there is no tree at all.

4. **What does the verifier learn? What does it NOT learn?**
   Learns: a valid commitment exists in the Merkle tree with this root.
   Does NOT learn: which leaf it is, what the secret is, or who the prover is.
   Note: if the same commitment appears in multiple proofs, an observer can link
   those actions to the same identity — this is the linkability problem (not yet solved).

5. **How did `/nargo-test` change the workflow?**
   It runs directly via a slash command — no need to navigate to the directory or
   type the command manually. One keystroke replaces context-switching.

## What Worked

Reviewing the complete Merkle tree cycle — path tracing, `hash_pair`, and
`compute_merkle_root` — made the structure concrete. The incremental approach
(design the loop logic first, then code one function at a time) worked well and
prevented mistakes before they happened.

## What Didn't

The initial test provided had 3 siblings (depth 3), but the planned tree was depth 2
(4 leaves = 2 siblings). The mismatch caused a compile error and required adjusting
the circuit depth. Also discovered an open gap: publishing the same commitment multiple
times allows an observer to link actions to the same identity — the **linkability
problem** — which this circuit does not yet address.

## Key Learnings

- The Merkle path loop needs `indices` to correctly place the current node as left or
  right child at each level. Without them, the computed root is wrong for half the tree.
- Both circuit constraints are necessary and non-redundant: one proves secret ownership,
  the other proves tree membership. Either one alone is exploitable.
- Custom slash commands (`/nargo-test`) require a session restart to appear, but once
  loaded they eliminate repetitive terminal context-switching.
- The **linkability problem**: reusing the same commitment across multiple proofs leaks
  correlatable identity information to observers, even without revealing the secret.
  Solution: nullifiers (Day 4 topic).
