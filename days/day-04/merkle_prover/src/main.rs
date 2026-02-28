  use std::process::Command;
  use std::path::Path;
  use std::fs::write;

  fn write_prover_toml(circuit_dir: &Path, secret: &str, commitment: &str,
                       path: [&str; 2], indices: [&str; 2], root: &str) {
      // write Prover.toml to circuit_dir
      let toml = format!(
          "secret = \"{secret}\"\ncommitment = \"{commitment}\"\npath = [\"{}\", \"{}\"]\nindices = [\"{}\", \"{}\"]\nroot = \"{root}\"\n",
          path[0], path[1], indices[0], indices[1]
      );

      write(circuit_dir.join("Prover.toml"), toml).expect("Failed to write Prover.toml");
  }

  fn run(cmd: &str, args: &[&str], dir: &Path) {
      let output = Command::new(cmd)
          .args(args)
          .current_dir(dir)
          .status()
          .expect(&format!("Failed to execute command: {}", cmd));
      
      if !output.success() {
          panic!("Command failed: {} with args {:?}", cmd, args);
      }
  }

  fn main() {
      let circuit_dir = Path::new("../../../project/circuits/merkle_membership");

      // hardcoded values we computed from Noir
//       secret = "1"
// path = ["2", "0x266d452e34d9880b41e076343099570c3743664aeee94312a026102bdb6e8a0b"]
// indices = ["0", "0"]
// commitment = "0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373"
// root = "0x0a38a83896b7a84e5df368f2ee03d0d8e79c5fac9354af59cebb17dc78305ca7"


      write_prover_toml(circuit_dir, "1", "0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373",
                        ["2", "0x266d452e34d9880b41e076343099570c3743664aeee94312a026102bdb6e8a0b"],
                        ["0", "0"],
                        "0x0a38a83896b7a84e5df368f2ee03d0d8e79c5fac9354af59cebb17dc78305ca7");

      run("nargo", &["execute"], circuit_dir);
      run("bb", &["write_vk", "-b", "target/merkle_membership.json", "-o", "target/"], circuit_dir);
      run("bb", &["prove", "-b", "target/merkle_membership.json", "-w", "target/merkle_membership.gz", "-o", "target/"], circuit_dir);
      run("bb", &["verify", "-k", "target/vk", "-p", "target/proof"], circuit_dir);
      println!("Proof verified!");
  }

