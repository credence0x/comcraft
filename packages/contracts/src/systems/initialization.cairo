#[dojo::contract]
mod initialization_systems {
     
    use comcraft::alias::ID;
    use comcraft::models::config::GameConfig;
    use comcraft::models::item::ItemPrototype;
    use comcraft::prototypes::blocks::block_types;
    use comcraft::constants::GodID;
    use comcraft::prototypes::recipes;

    trait IInitializationSystems<TContractState> {
        fn init(self: @TContractState, world: IWorldDispatcher);
        fn init2(self: @TContractState, world: IWorldDispatcher);
    }

    #[external(v0)]
    impl InitializationSystemsImpl of IInitializationSystems<ContractState> {
            
        fn init(self: @ContractState, world: IWorldDispatcher) {

            set!(world, (
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
                set!(world, (
                    ItemPrototype {
                        id: (*blocks[i]).into(),
                        value: true
                    }
                ));
                i += 1;
            };
        }
    

        fn init2(self: @ContractState, world: IWorldDispatcher) {
            recipes::define_recipes(world);
        }
    }
        
}
