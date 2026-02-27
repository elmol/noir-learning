use poseidon::poseidon2;

fn main(secret: Field, path: [Field; 2], indices: [u1; 2], commitment: pub Field, root: pub Field) {
    let computed_commitment = poseidon2::Poseidon2::hash([secret], 1);
    assert(commitment == computed_commitment, "Commitment does not match the computed value");
    let computed_root = compute_merkle_root(computed_commitment, path, indices);
    assert(root == computed_root, "Merkle root does not match the computed value");
}

fn hash_pair(left: Field, right: Field) -> Field {
    poseidon2::Poseidon2::hash([left, right], 2)
}

fn compute_merkle_root(leaf: Field, path: [Field; 2], indices: [u1; 2]) -> Field {
    let mut current_hash = leaf;
    for i in 0..2 {
        let sibling = path[i];
        if indices[i] == 0 {
            current_hash = hash_pair(current_hash, sibling);
        } else {
            current_hash = hash_pair(sibling, current_hash);
        }
    }
    current_hash
}

#[test]
fn test_main() {
    let secret = 1;
    let commitment = poseidon2::Poseidon2::hash([secret], 1);

    let h01 = hash_pair(commitment, 2);

    let h23 = hash_pair(3, 4);
    let root = hash_pair(h01, h23);
    main(secret, [2, h23], [0, 0], commitment, root);
}


  #[test(should_fail)]                                                                                                                                                                  
  fn test_wrong_root() {                                    
      let secret: Field = 1;
      let commitment = poseidon2::Poseidon2::hash([secret], 1);
      let h01 = hash_pair(commitment, 2);
      let h23 = hash_pair(3, 4);
      let root = hash_pair(h01, h23);
      // Intentionally provide an incorrect root to trigger the failure
      main(secret, [2, h23], [0, 0], commitment, root + 1);
  }
