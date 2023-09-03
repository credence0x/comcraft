#[system]
mod Mine {
    use comcraft::alias::ID;
    use comcraft::components::item::Item;
    use comcraft::components::owned_by::OwnedBy;
    
    use comcraft::components::position::{Position3D,PositionOccupation, Position};
    use comcraft::systems::claim::{MakeClaim};
    use comcraft::systems::occurrence::{Occurence};
    use comcraft::libraries::terrain;
    use comcraft::prototypes::blocks;

    use orion::numbers::signed_integer::i32::{i32, i32Impl};

    use dojo::world::Context;

    use starknet::ContractAddress;
    use starknet::contract_address_const;

    use core::traits::Into;



    fn execute(ctx: Context, coord: Position3D, block_type: felt252) -> ID {

        assert(block_type != blocks::AirID, 'can not mine air');
        assert(block_type != blocks::WaterID, 'can not mine water');
        assert(coord.y < i32Impl::new(256,false) && coord.y >= i32Impl::new(63, true), 'out of chunk bounds');

        let claimer = MakeClaim::get_claim_at_coord(ctx.world, coord).claimer;
        assert(claimer == contract_address_const::<0>() || claimer == ctx.origin, 'cant mine in claimed chunk');

        let position_occupation = get!(ctx.world, (coord.x, coord.y, coord.z ), (PositionOccupation));
        let mut entity_id: ID = 0;

        if (position_occupation.occupied_by_non_air == 0 && position_occupation.occupied_by_air == 0) {
                // If there is no entity at this position,
                // try mining the terrain block at this position
                let occurrence = Occurence::get_occurrence(block_type, coord);
                assert( occurrence != 0 && occurrence == block_type, 'invalid terrain block type');

                // Create an ECS block from this coord's terrain block
                entity_id = ctx.world.uuid().into();
                set!(ctx.world, (
                    Item {
                        id: entity_id,
                        value: block_type
                    }
                ));

                // Place an air block at this position
                let air_entity: u256 = ctx.world.uuid().into();
                set!(ctx.world, (
                    Item {
                        id: air_entity,
                        value: blocks::AirID
                    },
                    Position {
                        id: air_entity,
                        x: coord.x,
                        y: coord.y,
                        z: coord.z
                    },
                    PositionOccupation {
                        x: coord.x,
                        y: coord.y,
                        z: coord.z,
                        occupied_by_air: air_entity,
                        occupied_by_non_air: 0
                    }
                ));

        } else {

            // Else, mine the non-air entity block at this position
            entity_id = position_occupation.occupied_by_non_air;
            assert(entity_id != 0, 'invalid block type e:a');
            
            let item = get!(ctx.world, entity_id, (Item));
            assert(item.value == block_type, 'invalid block type e:b');
            
            set!(ctx.world, (
                    // remove position
                    Position {
                        id: entity_id,
                        x: i32Impl::new(0, false),
                        y: i32Impl::new(0, false),
                        z: i32Impl::new(0, false)
                    },
                    PositionOccupation {
                        x: coord.x,
                        y: coord.y,
                        z: coord.z,
                        occupied_by_air: position_occupation.occupied_by_air,
                        occupied_by_non_air: 0
                    }
                )
            );
        }

        set!(ctx.world, (
            OwnedBy {
                id: entity_id,
                address: ctx.origin
            }
        ));
        
        entity_id

    }
        
}
