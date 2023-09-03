#[system]
mod Transfer {
    use comcraft::alias::ID;
    use comcraft::components::item::Item;
    use comcraft::components::owned_by::OwnedBy;
    use starknet::ContractAddress;

    use dojo::world::Context;

    fn execute(ctx: Context, item_id: ID, receiver: ContractAddress) {

        let block_owned_by = get!(ctx.world, item_id, OwnedBy);        
        assert(block_owned_by.address == ctx.origin, 'block not owned by player');

        set!(ctx.world, (
            OwnedBy {
                id: item_id,
                address: receiver
            })
        );
    }
        
}

   
