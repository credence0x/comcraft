#[dojo::contract]
mod build_systems {
    use comcraft::alias::ID;
    use comcraft::models::position::{Position, PositionOccupation, VoxelCoord, VoxelCoordTrait};
    use comcraft::models::owned_by::OwnedBy;
    use comcraft::models::claim::Claim;
    use comcraft::models::item::Item;
    use comcraft::models::config::GameConfig;

    use comcraft::constants::GodID;

    use comcraft::systems::claim::claim_systems;
    
    use starknet::contract_address_const;

    trait IBuildSystems<TContractState> {
        fn build(
            self: @TContractState, world: IWorldDispatcher, block_id: ID, coord: VoxelCoord 
        );

        fn creative_build(
            self: @TContractState, 
            world: IWorldDispatcher, 
            block_id: ID, 
            coord: VoxelCoord
        );
    }

    #[external(v0)]
    impl BuildSystemsImpl of IBuildSystems<ContractState> {

        fn build(
            self: @ContractState, world: IWorldDispatcher, block_id: ID, coord: VoxelCoord 
        ) {
            let block_owned_by = get!(world, block_id, OwnedBy);        
            assert(block_owned_by.address == starknet::get_caller_address(), 'block not owned by player');

            // Require no other ECS blocks at this position except Air
            let VoxelCoord { x, y, z } = coord;
            let position_occupation = get!(
                world, 
                coord.hash(),
                PositionOccupation
            );
            if position_occupation.occupied_by_non_air != 0 {
                assert(false, 'cant build at occupied coord');
            }

            // Check claim in chunk
            let claim = claim_systems::get_claim_at_coord(world, coord);
            if claim.claimer != contract_address_const::<0>() && claim.claimer != block_owned_by.address {
                assert(false, 'cant build in claimed chunk');
            }

            set!(world, (
                    PositionOccupation { 
                        hash: coord.hash(),
                        occupied_by_non_air: block_id,
                        occupied_by_air: position_occupation.occupied_by_air
                    },
                    Position {
                        id: block_id,
                        x: x.mag,
                        x_neg: x.sign,
                        y: y.mag,
                        y_neg: y.sign,
                        z: z.mag,
                        z_neg: z.sign,
                    },
                    OwnedBy {
                        id: block_id,
                        address: contract_address_const::<0>()
                    }
                )
            );
        }



        fn creative_build(
            self: @ContractState, 
            world: IWorldDispatcher, 
            block_id: ID, 
            coord: VoxelCoord
        ) {
            let GodID_u256: ID = GodID.into();
            let game_config = get!(world, GodID_u256, GameConfig);
            assert(game_config.creative_mode == false, 'CREATIVE MODE DISABLED');

            let item = get!(world, block_id, Item);
            let block_type = item.value;

            let entity_id: u256 = world.uuid().into();
            let position_occupation = get!(
                world, 
                coord.hash(),
                PositionOccupation
            );
            set!(world, (
                Item {
                    id: entity_id,
                    value: block_type
                },
                Position {
                    id: entity_id,
                    x: coord.x.mag,
                    x_neg: coord.x.sign,
                    y: coord.y.mag,
                    y_neg: coord.y.sign,
                    z: coord.z.mag,
                    z_neg: coord.z.sign,
                },
                PositionOccupation {
                    hash: coord.hash(),
                    occupied_by_non_air: entity_id,
                    occupied_by_air: position_occupation.occupied_by_air
                }
            ));
        }
    }
}