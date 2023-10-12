#[dojo::contract]
mod name_systems {
    use comcraft::alias::ID;
    use comcraft::models::name::Name;

    trait INameSystems<TContractState> {
        fn add_name(self: @TContractState, world: IWorldDispatcher, entity_id: ID, name: felt252);
    }
    
    #[external(v0)]
    impl NameSystemsImpl of INameSystems<ContractState> {
        fn add_name(
            self: @ContractState, world: IWorldDispatcher, entity_id: ID, name: felt252
        ) {

            // assert(
            //     starknet::get_caller_address() == 0x27C41B2D2368085EF6fe7Dd66Cf32EB01e0e0658,
            //          'Only oracle can call'
            // );

            set!(world, (
                Name {
                    id: entity_id,
                    value: name,
                })
            );
        }
    }
    
}