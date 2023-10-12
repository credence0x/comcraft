use comcraft::prototypes::blocks;
use comcraft::models::recipe::{Recipe, RecipeReverseLookup};

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use core::poseidon::poseidon_hash_span;
use core::array::ArrayTrait;
use core::traits::Into;

fn define_recipes(world: IWorldDispatcher) {
    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::PlanksID);
    recipe.append(blocks::PlanksID);
    recipe.append(blocks::PlanksID);
    recipe.append(blocks::PlanksID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::CraftingID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::CraftingID.into()
        }
    ));

    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::LogID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::PlanksID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::PlanksID.into()
        }
    ));

    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::OrangeFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::OrangeWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::OrangeWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::MagentaFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::MagentaWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::MagentaWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::LightBlueFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::LightBlueWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::LightBlueWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::RedFlowerID);
    recipe.append(blocks::KelpID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::YellowWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::YellowWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::LimeFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::LimeWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::LimeWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::PinkFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::PinkWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::PinkWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::GrayFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::GrayWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::GrayWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::LightGrayFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::LightGrayWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::LightGrayWoolID.into()
        }

    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::CyanFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::CyanWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::CyanWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::PurpleFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::PurpleWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::PurpleWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::BlueFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::BlueWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::BlueWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::DirtID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::BrownWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::BrownWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::GreenFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::GreenWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::GreenWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::RedFlowerID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::RedWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::RedWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::WoolID);
    recipe.append(blocks::BlackFlowerID);
    
    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::BlackWoolID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::BlackWoolID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::StoneID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::CobblestoneID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::CobblestoneID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::GrassPlantID);
    recipe.append(blocks::CobblestoneID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::MossyCobblestoneID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::MossyCobblestoneID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    // clay
    recipe.append(blocks::ClayID);
    recipe.append(blocks::ClayID);
    recipe.append(blocks::ClayID);
    recipe.append(blocks::ClayID);
    // coal
    recipe.append(blocks::CoalID);
    // clay
    recipe.append(blocks::ClayID);
    recipe.append(blocks::ClayID);
    recipe.append(blocks::ClayID);
    recipe.append(blocks::ClayID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::BricksID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::BricksID.into()
        }
    ));


    let mut recipe: Array<felt252> = array![];
    recipe.append(blocks::SandID);
    recipe.append(blocks::CoalID);

    let hash: felt252 = poseidon_hash_span(recipe.span());
    set!(world, (
        Recipe {
            id: blocks::GlassID.into(),
            value: hash
        },
        RecipeReverseLookup {   
            value: hash,
            id: blocks::GlassID.into()
        }
    ));
}



