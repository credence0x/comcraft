use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct OwnedBy {
    #[key]
    id: u256,
    address: ContractAddress
}