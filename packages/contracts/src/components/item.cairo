#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Item {
    #[key]
    id: u256,
    value: felt252
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct ItemPrototype {
    #[key]
    id: u256,
    value: bool
}

