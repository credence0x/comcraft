#[system]
mod Craft {
    use comcraft::alias::ID;
    use comcraft::components::item::Item;
    use comcraft::components::owned_by::OwnedBy;
    use comcraft::components::recipe::{Recipe, RecipeReverseLookup};

    use dojo::world::Context;

    use starknet::contract_address_const;

    use core::traits::{Into, TryInto};
    use core::option::OptionTrait;
    use core::array::{SpanTrait,ArrayTrait};
    use core::poseidon::poseidon_hash_span;



    fn execute(ctx: Context, ingredients: Span<ID>) -> ID {

        let mut ingredient_types: Array<felt252> = array![];

        let mut i = 0;
        loop {
            if i >= ingredients.len() {
                break;
            }
            let ingredient = *ingredients[i];
            if ingredient != 0 {
                let owned_by = get!(ctx.world, ingredient, OwnedBy);
                assert(owned_by.address == ctx.origin, 'not owned by player');

                let ingredient_item = get!(ctx.world, ingredient, Item);
                ingredient_types.append(ingredient_item.value);
            }
            i+=1;
        };
        
        let recipe_hash: felt252 = poseidon_hash_span(ingredient_types.span());

        let recipe = get!(ctx.world, recipe_hash, RecipeReverseLookup);
        assert(recipe.id != 0 , 'no recipes found');

        // Burn all ingredients
        let mut i = 0;
        loop {
            if i >= ingredients.len() {
                break;
            }
            let ingredient = *ingredients[i];
            if ingredient != 0 {
                set!(ctx.world, (
                    OwnedBy {
                        id: ingredient,
                        address: contract_address_const::<0>()
                    }
                ));
            }
            i+=1;
        };

        // Create the output entity
        let entity_id: u256 = ctx.world.uuid().into();
        set!(ctx.world, (
            OwnedBy {
                id: entity_id,
                address: ctx.origin
            },
            Item {
                id: entity_id,
                value: (recipe.id).try_into().unwrap()
            }
        ));


        entity_id

    }        
}
