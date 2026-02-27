fn main(x: Field, y: pub Field) {
    assert(x == y);
}

#[test]
fn test_main() {
    main(1, 1);
}

#[test(should_fail)]
fn test_main_should_fail() {
    main(1, 2);
}   