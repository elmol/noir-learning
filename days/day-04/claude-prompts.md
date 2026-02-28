# Day 4 — Claude Code Prompts

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

> "The file Prover.toml is used as an input file... nargo prove doesn't exist anymore in the
> new version of Noir. Please recheck all and update all your information, taking into account
> that we are using the latest version v1.0.0-beta.18."

### Result

Claude Code ran `nargo --version`, discovered the correct version, updated CLAUDE.md to reflect
the real pipeline (`nargo execute` + `bb write_vk` + `bb prove` + `bb verify`), and removed all
references to the obsolete `nargo prove` / `nargo verify` commands across the project.

### Claude Code Insight

Claude Code's internal model of a tool's API can be out of date. When the user corrects a wrong
assumption with a concrete counter-example (running the command), Claude Code updates its state
and propagates the correction to all relevant files. Explicit correction is more reliable than
waiting for it to self-detect a discrepancy.

---

### Prompt

> "Need help with step 1 — in order to validate the Poseidon, detail step."
> (After discovering that `light-poseidon` hash values didn't match the circuit's expected values.)

### Result

Claude Code diagnosed the root cause: `light-poseidon` implements original Poseidon (Circom
parameters), not Poseidon2. It proposed extracting the correct hash values from Noir directly
using `std::println` in a debug test and running `nargo test test_print_values --show-output`.
This produced the exact Field values needed for Prover.toml:
- `commitment = 0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373`
- `h23 = 0x266d452e34d9880b41e076343099570c3743664aeee94312a026102bdb6e8a0b`
- `root = 0x0a38a83896b7a84e5df368f2ee03d0d8e79c5fac9354af59cebb17dc78305ca7`

### Claude Code Insight

When cross-language interoperability fails (two implementations of "the same" algorithm produce
different outputs), Claude Code's best move is to trust one side as the source of truth and
extract values from it. Using the circuit itself as the oracle — printing internal values from
a test — is a pattern that works regardless of what Rust libraries exist.

---

### Prompt

> "Review all files in this repository. Give me a retrospective: what did we build, what are
> the weak points in the circuit, what would you refactor, and what should I study next?"

### Result

Claude Code dispatched a subagent that read 10 files across the repository (circuit source,
Rust binary, CI workflow, notes, CLAUDE.md, LEARNINGS.md). It returned a structured retrospective
covering: the 4-day pipeline summary, 5 specific circuit weak points (hardcoded depth, no domain
separation, no nullifier, no blinding, fragile Rust integration), a prioritized refactor list,
and a study plan (Plonk/UltraHonk, Semaphore protocol, generic Merkle depth, `noir_js`).

### Claude Code Insight

A retrospective prompt that asks for weak points and what to study next produces a better security
audit than asking "is this circuit correct?" The framing forces Claude Code to look for gaps
rather than confirm correctness. The file-reading pattern ensures the answer is grounded in
actual code, not the conversation history.
