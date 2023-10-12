#[derive(Model, Copy, Drop, Serde)]
struct GameConfig{
    #[key]
    id: u256,
    creative_mode: bool
}

const GameConfigID: felt252 = 'GameConfigID';