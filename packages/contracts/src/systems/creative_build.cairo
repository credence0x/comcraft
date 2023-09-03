#[system]
mod CreativeBuild  {
    use comcraft::alias::ID;
    use comcraft::components::config::GameConfig;
    use comcraft::components::item::Item;
    use comcraft::components::position::{Position, PositionOccupation, Position3D};

    use comcraft::constants::GodID;

    use dojo::world::Context;

    use core::traits::Into;

    fn execute(ctx: Context, block_id: ID, coord: Position3D) {
        let GodID_u256: ID = GodID.into();
        let game_config = get!(ctx.world, GodID_u256, GameConfig);
        assert(game_config.creative_mode == false, 'CREATIVE MODE DISABLED');

        let item = get!(ctx.world, block_id, Item);
        let block_type = item.value;

        let entity_id: u256 = ctx.world.uuid().into();
        let position_occupation = get!(ctx.world, (coord.x, coord.y, coord.z), PositionOccupation);
        set!(ctx.world, (
            Item {
                id: entity_id,
                value: block_type
            },
            Position {
                id: entity_id,
                x: coord.x,
                y: coord.y,
                z: coord.z
            },
            PositionOccupation {
                x: coord.x,
                y: coord.y,
                z: coord.z,
                occupied_by_non_air: entity_id,
                occupied_by_air: position_occupation.occupied_by_air
            }
        ));
    }        
}
