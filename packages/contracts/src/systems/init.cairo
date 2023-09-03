#[system]
mod Init {
    use comcraft::alias::ID;
    use comcraft::components::config::GameConfig;
    use comcraft::components::item::ItemPrototype;
    use comcraft::prototypes::blocks::block_types;
    use comcraft::constants::GodID;

    use dojo::world::Context;

    use core::array::ArrayTrait;
    use core::traits::Into;

    fn execute(ctx: Context) {

        set!(ctx.world, (
            GameConfig {
                id: GodID.into(),
                creative_mode: false
            }
        ));

        let mut i = 0;
        let blocks = block_types();
        loop {
            if i >= blocks.len() {
                break;
            }
            set!(ctx.world, (
                ItemPrototype {
                    id: (*blocks[i]).into(),
                    value: true
                }
            ))
            i += 1;
        };
    }
        
}
