#[dojo::contract]
mod minecraft_systems {
    use comcraft::alias::ID;
    use comcraft::models::item::Item;
    use comcraft::models::owned_by::OwnedBy;
    
    use comcraft::models::position::{VoxelCoord, VoxelCoordTrait, PositionOccupation, Position};
    use comcraft::systems::claim::{claim_systems};
    use comcraft::systems::occurrence::{occurence_systems};
    use comcraft::libraries::terrain;
    use comcraft::prototypes::blocks;

    use orion::numbers::signed_integer::i32::{i32, i32Impl};

    use starknet::ContractAddress;
    use starknet::contract_address_const;

    use comcraft::models::recipe::RecipeReverseLookup;


    use core::poseidon::poseidon_hash_span;


    trait IMineCraftSystems<TContractState> {
        fn mine(
            self: @TContractState, 
            world: IWorldDispatcher, 
            coord: VoxelCoord, 
            block_type: felt252
        ) -> ID;

        fn craft(self: @TContractState, world: IWorldDispatcher, ingredients: Span<ID>) -> ID;
    }
        
    #[external(v0)]
    impl MineCraftSystemsImpl of IMineCraftSystems<ContractState> {

        fn mine(
            self: @ContractState, 
            world: IWorldDispatcher, 
            coord: VoxelCoord, 
            block_type: felt252
        ) -> ID {

            assert(block_type != blocks::AirID, 'can not mine air');
            assert(block_type != blocks::WaterID, 'can not mine water');
            assert(coord.y < i32Impl::new(256,false) && coord.y >= i32Impl::new(63, true), 'out of chunk bounds');

            let claimer = claim_systems::get_claim_at_coord(world, coord).claimer;
            assert(claimer == contract_address_const::<0>() || claimer == starknet::get_caller_address(), 'cant mine in claimed chunk');

            let position_occupation = get!(
                world, 
                coord.hash(),
                (PositionOccupation)
            );
            let mut entity_id: ID = 0;

            if (position_occupation.occupied_by_non_air == 0 && position_occupation.occupied_by_air == 0) {
                    // If there is no entity at this position,
                    // try mining the terrain block at this position
                    let occurrence = occurence_systems::get_occurrence(block_type, coord);
                    assert( occurrence != 0 && occurrence == block_type, 'invalid terrain block type');

                    // Create an ECS block from this coord's terrain block
                    entity_id = world.uuid().into();
                    set!(world, (
                        Item {
                            id: entity_id,
                            value: block_type
                        }
                    ));

                    // Place an air block at this position
                    let air_entity: u256 = world.uuid().into();
                    set!(world, (
                        Item {
                            id: air_entity,
                            value: blocks::AirID
                        },
                        Position {
                            id: air_entity,
                            x: coord.x.mag,
                            x_neg: coord.x.sign,
                            y: coord.y.mag,
                            y_neg: coord.y.sign,
                            z: coord.z.mag,
                            z_neg: coord.z.sign,
                        },
                        PositionOccupation {
                            hash: coord.hash(),
                            occupied_by_air: air_entity,
                            occupied_by_non_air: 0
                        }
                    ));

            } else {

                // Else, mine the non-air entity block at this position
                entity_id = position_occupation.occupied_by_non_air;
                assert(entity_id != 0, 'invalid block type e:a');
                
                let item = get!(world, entity_id, (Item));
                assert(item.value == block_type, 'invalid block type e:b');
                
                set!(world, (
                        // remove position
                        Position {
                            id: entity_id,
                            x: 0,
                            x_neg: false,
                            y: 0,
                            y_neg: false,
                            z: 0,
                            z_neg: false,
                        },
                        PositionOccupation {
                            hash: coord.hash(),
                            occupied_by_air: position_occupation.occupied_by_air,
                            occupied_by_non_air: 0
                        }
                    )
                );
            }

            set!(world, (
                OwnedBy {
                    id: entity_id,
                    address: starknet::get_caller_address()
                }
            ));
            
            entity_id
        }


        
        fn craft(self: @ContractState, world: IWorldDispatcher, ingredients: Span<ID>) -> ID {

            let mut ingredient_types: Array<felt252> = array![];

            let mut i = 0;
            loop {
                if i >= ingredients.len() {
                    break;
                }
                let ingredient = *ingredients[i];
                if ingredient != 0 {
                    let owned_by = get!(world, ingredient, OwnedBy);
                    assert(owned_by.address == starknet::get_caller_address(), 'not owned by player');

                    let ingredient_item = get!(world, ingredient, Item);
                    ingredient_types.append(ingredient_item.value);
                }
                i+=1;
            };
            
            let recipe_hash: felt252 = poseidon_hash_span(ingredient_types.span());

            let recipe = get!(world, recipe_hash, RecipeReverseLookup);
            assert(recipe.id != 0 , 'no recipes found');

            // Burn all ingredients
            let mut i = 0;
            loop {
                if i >= ingredients.len() {
                    break;
                }
                let ingredient = *ingredients[i];
                if ingredient != 0 {
                    set!(world, (
                        OwnedBy {
                            id: ingredient,
                            address: contract_address_const::<0>()
                        }
                    ));
                }
                i+=1;
            };

            // Create the output entity
            let entity_id: u256 = world.uuid().into();
            set!(world, (
                OwnedBy {
                    id: entity_id,
                    address: starknet::get_caller_address()
                },
                Item {
                    id: entity_id,
                    value: (recipe.id).try_into().unwrap()
                }
            ));


            entity_id

        }        
    }    
}
