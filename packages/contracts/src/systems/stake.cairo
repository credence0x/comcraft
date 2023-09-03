#[system]
mod MakeStake {
    use comcraft::alias::ID;
    use comcraft::components::position::{Coord, VoxelCoord};
    use comcraft::components::item::Item;
    use comcraft::components::owned_by::OwnedBy;
    use comcraft::components::claim::Claim;
    use comcraft::components::stake::Stake;
    use comcraft::prototypes::{blocks};
    use comcraft::utils::{u256Helpers, u64Helpers, get_chunk_coord};
    use starknet::ContractAddress;
    use starknet::contract_address_const;


    use dojo::world::Context;

    use core::traits::Into;
    use core::array::ArrayTrait;
    use core::option::OptionTrait;


    // Stake entity = concat(address | chunk.x | chunk.y)
    fn get_stake_entity(chunk: Coord, entity: ContractAddress) -> ID {
        let entity_felt: felt252 = entity.into();
        let entity_u256: u256 = entity_felt.into();
        (u256Helpers::shl(entity_u256, 64) | (u64Helpers::shl(chunk.x.mag.into(), 32_u64) | chunk.y.mag.into()).into())
    }

    fn get_stake_in_chunk(world: IWorldDispatcher, stake_id: ID) -> Stake {
        get!(world, stake_id, Stake)
    }

    fn execute(ctx: Context, block_id: ID, chunk: Coord) {

        let block_owned_by = get!(ctx.world, block_id, OwnedBy);        
        assert(block_owned_by.address == ctx.origin, 'block not owned by player');

        let block_item = get!(ctx.world, block_id, Item);
        assert(block_item.value == blocks::DiamondID, 'can only stake diamond blocks');

        // Remove block from inventory and place it in the world
        set!(ctx.world, (
            OwnedBy {
                id: block_id,
                address: contract_address_const::<0>()
            })
        );

        // Increase stake in this chunk
        let stake_id = get_stake_entity(chunk, ctx.origin);
        let stake = get_stake_in_chunk(ctx.world, stake_id);
        set!(ctx.world, (
            Stake {
                id: stake_id,
                value: stake.value + 1
            })
        );
    }
        
}

   
