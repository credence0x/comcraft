use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct OwnedBy {
    #[key]
    id: u256,
    address: ContractAddress
}