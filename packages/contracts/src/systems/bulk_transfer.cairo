#[system]
mod BulkTransfer {
    use comcraft::alias::ID;
    use comcraft::components::owned_by::OwnedBy;

    use dojo::world::Context;

    use starknet::ContractAddress;

    use core::array::{SpanTrait};

    fn execute(ctx: Context, item_ids: Span<ID>, receiver: ContractAddress) {

        let mut i = 0;
        loop {
            if i >= item_ids.len() {
                break;
            }

            let item_id = *item_ids[i];
            
            // Require block to be owned by caller
            let owned_by = get!(ctx.world, item_id, OwnedBy);
            assert(owned_by.address == ctx.origin, 'not owned by player');
            
             // Transfer ownership of the item
            set!(ctx.world, (
                OwnedBy {
                    id: item_id,
                    address: receiver
                }
            ));
            
            i+=1;
        };
    }        
}
