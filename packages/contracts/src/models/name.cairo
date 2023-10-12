#[derive(Model, Copy, Drop, Serde)]
struct Name {
    #[key]
    id: u256,
    value: felt252
}
