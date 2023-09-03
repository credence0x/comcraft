#[system]
mod MakeClaim {
    use comcraft::alias::ID;
    use comcraft::components::position::{Coord, VoxelCoord, PositionOccupation};
    use comcraft::components::item::Item;
    use comcraft::components::owned_by::OwnedBy;
    use comcraft::components::claim::Claim;
    use comcraft::components::stake::Stake;
    use comcraft::systems::stake::{MakeStake};
    use comcraft::utils::{u64Helpers, get_chunk_coord};

    use dojo::world::Context;

    use core::traits::Into;
    use core::array::ArrayTrait;
    use core::option::OptionTrait;


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


    fn execute(ctx: Context, chunk: Coord ) {
         
        let sender_stake_in_chunk: Stake = MakeStake::get_stake_in_chunk(
            ctx.world, 
            MakeStake::get_stake_entity(chunk, ctx.origin)
        );
        let current_claim_in_chunk: Claim = get_claim_in_chunk(ctx.world, chunk);

        assert(sender_stake_in_chunk.value > current_claim_in_chunk.stake, 'not enough staked');

        // Claim this chunk
        let chunk_entity: ID = get_chunk_entity(chunk);
        set!(ctx.world, Claim {id: chunk_entity, stake: sender_stake_in_chunk.value, claimer: ctx.origin});
    }

}