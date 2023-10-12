#[derive(Model, Copy, Drop, Serde)]
struct Stake {
    #[key]
    id: u256,
    value: u32
}
