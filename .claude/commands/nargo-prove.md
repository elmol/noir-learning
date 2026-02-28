Run the full prove pipeline in the current directory using the Bash tool and report the results:
1. `nargo compile` to compile the circuit
2. `nargo execute` to generate the witness from Prover.toml
3. `bb write_vk -b target/<name>.json -o target/` to generate the verification key
4. `bb prove -b target/<name>.json -w target/<name>.gz -o target/` to generate the proof
5. `bb verify -k target/vk -p target/proof` to verify the proof

Infer the circuit name from the Nargo.toml package name. Report each step result and the final verification outcome.
