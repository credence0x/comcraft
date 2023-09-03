#[system]
mod Init2 {
    use comcraft::prototypes::recipes;
    use dojo::world::Context;
 
    fn execute(ctx: Context) {
        recipes::define_recipes(ctx.world);
    }
        
}
