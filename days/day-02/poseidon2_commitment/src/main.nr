use poseidon::poseidon2;

fn main(secret: Field, commitment: pub Field) {
    let computed_commitment = poseidon2::Poseidon2::hash([secret], 1);
    assert(commitment == computed_commitment, "Commitment does not match the computed value");
}

#[test]
fn test_main() {
    let secret = 1;
    let commitment = poseidon2::Poseidon2::hash([secret], 1);
    main(secret, commitment);
}

#[test(should_fail)]
fn test_main_should_fail() {
    main(1, 2);
}
