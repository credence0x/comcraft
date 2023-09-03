#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Recipe {
    #[key]
    id: u256,
    value: felt252
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct RecipeReverseLookup {
    id: u256,
    #[key]
    value: felt252, // value is the lookup key
}