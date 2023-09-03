#[system]
mod Occurence {
    use comcraft::components::position::{Position3D};
    use comcraft::libraries::terrain;
    use comcraft::prototypes::blocks;

    use dojo::world::Context;

    fn execute(ctx: Context, block_type: felt252, coord: Position3D) -> felt252 {
        get_occurrence(block_type, coord)
    }

    fn get_occurrence(block_type: felt252, coord: Position3D) -> felt252 {
        if block_type == blocks::GrassID {return terrain::Grass(coord);}
        if block_type == blocks::DirtID {return terrain::Dirt(coord);}
        if block_type == blocks::StoneID {return terrain::Stone(coord);}
        if block_type == blocks::SandID {return terrain::Sand(coord);}
        if block_type == blocks::WaterID {return terrain::Water(coord);}
        if block_type == blocks::DiamondID {return terrain::Diamond(coord);}
        if block_type == blocks::CoalID {return terrain::Coal(coord);}
        if block_type == blocks::SnowID {return terrain::Snow(coord);}
        if block_type == blocks::ClayID {return terrain::Clay(coord);}
        if block_type == blocks::BedrockID {return terrain::Bedrock(coord);}

        if block_type == blocks::LogID {return terrain::Structure(coord);}
        if block_type == blocks::LeavesID {return terrain::Structure(coord);}
        if block_type == blocks::WoolID {return terrain::Structure(coord);}


        if block_type == blocks::RedFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::GrassPlantID {return terrain::SmallPlant(coord);}
        if block_type == blocks::OrangeFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::MagentaFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::LightBlueFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::LimeFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::PinkFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::GrayFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::LightGrayFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::CyanFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::PurpleFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::BlueFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::GreenFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::BlackFlowerID {return terrain::SmallPlant(coord);}
        if block_type == blocks::KelpID {return terrain::SmallPlant(coord);}

        0
    }
        
}

   