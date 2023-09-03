#[system]
mod AddName {
    use comcraft::alias::ID;
    use comcraft::components::name::Name;

    use dojo::world::Context;

    fn execute(ctx: Context, entity_id: ID, name: felt252) {

        assert(ctx.origin == 0x27C41B2D2368085EF6fe7Dd66Cf32EB01e0e0658, 'Only oracle can call');

        set!(ctx.world, (
            Name {
                id: entity_id,
                value: name,
            })
        );
    }
}

   
