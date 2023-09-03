#[system]
mod CreativeBuild  {
    use comcraft::alias::ID;
    use comcraft::components::config::GameConfig;
    use comcraft::components::item::Item;
    use comcraft::components::position::{Position, PositionOccupation, VoxelCoord, VoxelCoordTrait};

    use comcraft::constants::GodID;

    use dojo::world::Context;

    use core::traits::Into;

    fn execute(ctx: Context, block_id: ID, coord: VoxelCoord) {
        let GodID_u256: ID = GodID.into();
        let game_config = get!(ctx.world, GodID_u256, GameConfig);
        assert(game_config.creative_mode == false, 'CREATIVE MODE DISABLED');

        let item = get!(ctx.world, block_id, Item);
        let block_type = item.value;

        let entity_id: u256 = ctx.world.uuid().into();
        let position_occupation = get!(
            ctx.world, 
            coord.hash(),
            PositionOccupation
        );
        set!(ctx.world, (
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
