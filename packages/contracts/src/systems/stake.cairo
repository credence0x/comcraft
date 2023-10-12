#[dojo::contract]
mod stake_systems {
    use comcraft::alias::ID;
    use comcraft::models::position::{Coord, VoxelCoord};
    use comcraft::models::item::Item;
    use comcraft::models::owned_by::OwnedBy;
    use comcraft::models::claim::Claim;
    use comcraft::models::stake::Stake;

    use comcraft::prototypes::{blocks};
    use comcraft::utils::{u256Helpers, u64Helpers, get_chunk_coord};
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    
    trait IStakeSystems<TContractState> {
        fn stake(
            self: @TContractState, 
            world: IWorldDispatcher, 
            block_id: ID, 
            chunk: Coord
        );

        fn bulk_stake(
            self: @TContractState, 
            world: IWorldDispatcher, 
            block_ids: Span<ID>, 
            chunk: Coord
        );
    }

    #[external(v0)]
    impl StakeSystemsImpl of IStakeSystems<ContractState> {
        fn stake(
            self: @ContractState, 
            world: IWorldDispatcher, 
            block_id: ID, 
            chunk: Coord
        ) {
            let block_owned_by = get!(world, block_id, OwnedBy);        
            assert(block_owned_by.address == starknet::get_caller_address(), 'block not owned by player');

            let block_item = get!(world, block_id, Item);
            assert(block_item.value == blocks::DiamondID, 'can only stake diamond blocks');

            // Remove block from inventory and place it in the world
            set!(world, (
                OwnedBy {
                    id: block_id,
                    address: contract_address_const::<0>()
                })
            );

            // Increase stake in this chunk
            let stake_id = get_stake_entity(chunk, starknet::get_caller_address());
            let stake = get_stake_in_chunk(world, stake_id);
            set!(world, (
                Stake {
                    id: stake_id,
                    value: stake.value + 1
                })
            );
        }




   
        fn bulk_stake(
            self: @ContractState, 
            world: IWorldDispatcher, 
            block_ids: Span<ID>, 
            chunk: Coord
        ) {

            let mut i = 0;
            loop {
                if i >= block_ids.len() {
                    break;
                }

                let block_id = *block_ids[i];
                let block_owned_by = get!(world, block_id, OwnedBy);        
                assert(block_owned_by.address == starknet::get_caller_address(), 'block not owned by player');

                // block must be diamond
                let block_item = get!(world, block_id, Item);
                assert(block_item.value == blocks::DiamondID, 'can only stake diamond blocks');

                // Remove block from inventory and place it in the world
                set!(world, (
                    OwnedBy {
                        id: block_id,
                        address: contract_address_const::<0>()
                    })
                );

                i+=1;
            };


            // Increase stake in this chunk
            let stake_id = get_stake_entity(chunk, starknet::get_caller_address());
            let stake = get_stake_in_chunk(world, stake_id);
            set!(world, (
                Stake {
                    id: stake_id,
                    value: stake.value + block_ids.len()
                })
            );
        }
    }


    // Stake entity = concat(address | chunk.x | chunk.y)
    fn get_stake_entity(chunk: Coord, entity: ContractAddress) -> ID {
        let entity_felt: felt252 = entity.into();
        let entity_u256: u256 = entity_felt.into();
        (u256Helpers::shl(entity_u256, 64) | (u64Helpers::shl(chunk.x.mag.into(), 32_u64) | chunk.y.mag.into()).into())
    }

    fn get_stake_in_chunk(world: IWorldDispatcher, stake_id: ID) -> Stake {
        get!(world, stake_id, Stake)
    }


        
}

   
