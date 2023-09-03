#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Name {
    #[key]
    id: u256,
    value: felt252
}
