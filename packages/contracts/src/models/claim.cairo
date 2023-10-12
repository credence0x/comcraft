use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct Claim {
    #[key]
    id: u256,
    stake: u32,
    claimer: ContractAddress
}