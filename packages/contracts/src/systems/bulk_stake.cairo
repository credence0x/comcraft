#[system]
mod BulkStake {
    use comcraft::alias::ID;
    use comcraft::components::position::{Coord};
    use comcraft::components::item::Item;
    use comcraft::components::owned_by::OwnedBy;
    use comcraft::components::stake::Stake;
    use comcraft::systems::stake::{MakeStake};
    use comcraft::prototypes::{blocks};

    use dojo::world::Context;

    use starknet::contract_address_const;

    use core::traits::Into;
    use core::array::{ArrayTrait, SpanTrait};
    use core::option::OptionTrait;

   
    fn execute(ctx: Context, block_ids: Span<ID>, chunk: Coord) {

        let mut i = 0;
        loop {
            if i >= block_ids.len() {
                break;
            }

            let block_id = *block_ids[i];
            let block_owned_by = get!(ctx.world, block_id, OwnedBy);        
            assert(block_owned_by.address == ctx.origin, 'block not owned by player');

            // block must be diamond
            let block_item = get!(ctx.world, block_id, Item);
            assert(block_item.value == blocks::DiamondID, 'can only stake diamond blocks');

            // Remove block from inventory and place it in the world
            set!(ctx.world, (
                OwnedBy {
                    id: block_id,
                    address: contract_address_const::<0>()
                })
            );

            i+=1;
        };


        // Increase stake in this chunk
        let stake_id = MakeStake::get_stake_entity(chunk, ctx.origin);
        let stake = MakeStake::get_stake_in_chunk(ctx.world, stake_id);
        set!(ctx.world, (
            Stake {
                id: stake_id,
                value: stake.value + block_ids.len()
            })
        );
    }
        
}

   
