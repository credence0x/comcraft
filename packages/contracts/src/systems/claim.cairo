#[dojo::contract]
mod claim_systems {
    use comcraft::alias::ID;
    use comcraft::models::position::{Coord, VoxelCoord };
    use comcraft::models::item::Item;
    use comcraft::models::owned_by::OwnedBy;
    use comcraft::models::claim::Claim;
    use comcraft::models::stake::Stake;
    use comcraft::systems::stake::{stake_systems};
    use comcraft::utils::{u64Helpers, get_chunk_coord};


    trait IClaimSystems<TContractState> {
        fn make_claim(self: @TContractState, world: IWorldDispatcher, chunk: Coord );
    }
        
    #[external(v0)]
    impl ClaimSystemsImpl of IClaimSystems<ContractState> {

        fn make_claim(self: @ContractState, world: IWorldDispatcher, chunk: Coord ) {
            
            let sender_stake_in_chunk: Stake = stake_systems::get_stake_in_chunk(
                world, 
                stake_systems::get_stake_entity(chunk, starknet::get_caller_address())
            );

            let current_claim_in_chunk: Claim = get_claim_in_chunk(world, chunk);

            assert(
                sender_stake_in_chunk.value > current_claim_in_chunk.stake, 
                'not enough staked'
            );

            // Claim this chunk
            let chunk_entity: ID = get_chunk_entity(chunk);
            set!(world, (
                Claim {
                    id: chunk_entity, 
                    stake: sender_stake_in_chunk.value, 
                    claimer: starknet::get_caller_address()
                }
            ));
        }
    }



    // Chunk entity = concat(chunk.x | chunk.y)
    fn get_chunk_entity(chunk: Coord) -> ID {
        (u64Helpers::shl(chunk.x.mag.into(), 32_u64) | chunk.y.mag.into()).into()
    }
    
    fn get_claim_in_chunk(world: IWorldDispatcher, chunk: Coord) -> Claim  {
        get!(world, get_chunk_entity(chunk), Claim)
    }

    fn get_claim_at_coord(world: IWorldDispatcher, position: VoxelCoord) -> Claim {
        get_claim_in_chunk(world, get_chunk_coord(position))
    }


}