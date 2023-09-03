#[system]
mod Build  {
    use comcraft::alias::ID;
    use comcraft::components::position::{Position, PositionOccupation, Position3D};
    use comcraft::components::owned_by::OwnedBy;
    use comcraft::components::claim::Claim;
    use comcraft::systems::claim::{MakeClaim};

    use dojo::world::Context;
    
    use starknet::contract_address_const;


    fn execute(ctx: Context, block_id: ID, coord: Position3D ) {
        let block_owned_by = get!(ctx.world, block_id, OwnedBy);        
        assert(block_owned_by.address == ctx.origin, 'block not owned by player');

        // Require no other ECS blocks at this position except Air
        let Position3D { x, y, z } = coord;
        let position_occupation = get!(ctx.world, (x, y, z),  PositionOccupation);
        if position_occupation.occupied_by_non_air != 0 {
            assert(false, 'cant build at occupied coord');
        }

        // Check claim in chunk
        let claim = MakeClaim::get_claim_at_coord(ctx.world, coord);
        if claim.claimer != contract_address_const::<0>() && claim.claimer != block_owned_by.address {
            assert(false, 'cant build in claimed chunk');
        }

        set!(ctx.world, (
                PositionOccupation { 
                    x,y,z,
                    occupied_by_non_air: block_id,
                    occupied_by_air: position_occupation.occupied_by_air
                },
                Position {
                    id: block_id,
                    x,y,z
                },
                OwnedBy {
                    id: block_id,
                    address: contract_address_const::<0>()
                }
            )
        );
    }
    
}