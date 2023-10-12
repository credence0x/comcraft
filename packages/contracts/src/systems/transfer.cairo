#[dojo::contract]
mod transfer_systems {
    use comcraft::alias::ID;
    use comcraft::models::item::Item;
    use comcraft::models::owned_by::OwnedBy;
    use starknet::ContractAddress;

    trait ITransferSystems<TContractState> {
        fn transfer(
            self: @TContractState, 
            world: IWorldDispatcher, 
            item_id: ID, 
            receiver: ContractAddress
        );

        fn bulk_transfer(
            self: @TContractState, 
            world: IWorldDispatcher, 
            item_ids: Span<ID>, 
            receiver: ContractAddress
        );
    }

    
    #[external(v0)]
    impl TransferSystemsImpl of ITransferSystems<ContractState> {
        fn transfer(
            self: @ContractState, 
            world: IWorldDispatcher, 
            item_id: ID, 
            receiver: ContractAddress
        ) {

            let block_owned_by = get!(world, item_id, OwnedBy);        
            assert(block_owned_by.address == starknet::get_caller_address(), 'block not owned by player');

            set!(world, (
                OwnedBy {
                    id: item_id,
                    address: receiver
                })
            );
        }



        fn bulk_transfer(
            self: @ContractState, 
            world: IWorldDispatcher, 
            item_ids: Span<ID>, 
            receiver: ContractAddress
        ) {

            let mut i = 0;
            loop {
                if i >= item_ids.len() {
                    break;
                }

                let item_id = *item_ids[i];
                
                // Require block to be owned by caller
                let owned_by = get!(world, item_id, OwnedBy);
                assert(owned_by.address == starknet::get_caller_address(), 'not owned by player');
                
                // Transfer ownership of the item
                set!(world, (
                    OwnedBy {
                        id: item_id,
                        address: receiver
                    }
                ));
                
                i+=1;
            };
        }
    }       
}