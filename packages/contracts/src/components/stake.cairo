#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Stake {
    #[key]
    id: u256,
    value: u32
}
