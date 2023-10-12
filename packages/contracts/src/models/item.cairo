#[derive(Model, Copy, Drop, Serde)]
struct Item {
    #[key]
    id: u256,
    value: felt252
}

#[derive(Model, Copy, Drop, Serde)]
struct ItemPrototype {
    #[key]
    id: u256,
    value: bool
}

