use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Claim {
    #[key]
    id: u256,
    stake: u32,
    claimer: ContractAddress
}