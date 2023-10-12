#[derive(Model, Copy, Drop, Serde)]
struct Recipe {
    #[key]
    id: u256,
    value: felt252
}

#[derive(Model, Copy, Drop, Serde)]
struct RecipeReverseLookup {
    id: u256,
    #[key]
    value: felt252, // value is the lookup key
}