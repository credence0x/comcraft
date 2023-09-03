use comcraft::components::position::{Coord, VoxelCoord};
use comcraft::constants::{Biome, STRUCTURE_CHUNK, STRUCTURE_CHUNK_CENTER};
use comcraft::prototypes::blocks::{AirID, GrassID, DirtID, LogID, StoneID, SandID, GlassID, WaterID, CobblestoneID, MossyCobblestoneID, CoalID, CraftingID, IronID, GoldID, DiamondID, LeavesID, PlanksID, RedFlowerID, GrassPlantID, OrangeFlowerID, MagentaFlowerID, LightBlueFlowerID, LimeFlowerID, PinkFlowerID, GrayFlowerID, LightGrayFlowerID, CyanFlowerID, PurpleFlowerID, BlueFlowerID, GreenFlowerID, BlackFlowerID, KelpID, WoolID, OrangeWoolID, MagentaWoolID, LightBlueWoolID, YellowWoolID, LimeWoolID, PinkWoolID, GrayWoolID, LightGrayWoolID, CyanWoolID, PurpleWoolID, BlueWoolID, BrownWoolID, GreenWoolID, RedWoolID, BlackWoolID, SpongeID, SnowID, ClayID, BedrockID, BricksID};

use orion::numbers::signed_integer::i32::{i32, i32Impl};

use cubit::f128::procgen::simplex3;
use cubit::f128::types::fixed::{Fixed, FixedTrait, ONE_u128};
use cubit::f128::types::vec3::{Vec3Trait};

use core::poseidon::poseidon_hash_span;
use core::traits::{Into, TryInto};
use core::option::OptionTrait;
use core::array::{SpanTrait,ArrayTrait};


fn _0() -> Fixed {
    FixedTrait::new(0, false) // 0 * 2**64
}
fn _0_3() -> Fixed {
    FixedTrait::new(5534023222112865484, false) // 0.3 * 2**64
}
fn _0_4() -> Fixed {
    FixedTrait::new(7378697629483820646, false) // 0.4 * 2**64
}
fn _0_45() -> Fixed {
    FixedTrait::new(8301034833169298227, false) // 0.45 * 2**64
}
fn _0_49() -> Fixed {
    FixedTrait::new(9038904596117680291, false) // 0.49 * 2**64
}
fn _0_499() -> Fixed {
    FixedTrait::new(9204925292781066256, false) // 0.499 * 2**64
}
fn _0_501() -> Fixed {
    FixedTrait::new(9241818780928485359, false) // 0.501 * 2**64
}
fn _0_5() -> Fixed {
    FixedTrait::new(9223372036854775808, false) // 0.5 * 2**64
}
fn _0_51() -> Fixed {
    FixedTrait::new(9407839477591871324, false) // 0.51 * 2**64
}
fn _0_55() -> Fixed {
    FixedTrait::new(10145709240540253388, false) // 0.55 * 2**64
}
fn _0_6() -> Fixed {
    FixedTrait::new(11068046444225730969, false) // 0.6 * 2**64
}
fn _0_75() -> Fixed {
    FixedTrait::new(13835058055282163712, false) // 0.75 * 2**64
}
fn _0_8() -> Fixed {
    FixedTrait::new(14757395258967641292, false) // 0.8 * 2**64
}
fn _0_9() -> Fixed {
    FixedTrait::new(16602069666338596454, false) // 0.9 * 2**64
}
fn _1() -> Fixed {
    FixedTrait::new(ONE_u128, false) // 1 * 2**64
}
fn _2() -> Fixed {
    FixedTrait::new(2 * ONE_u128 , false) // 2 * 2**64
}
fn _3() -> Fixed {
    FixedTrait::new(3 * ONE_u128 , false) // 3 * 2**64
}
fn _4() -> Fixed {
    FixedTrait::new(4 * ONE_u128 , false) // 4 * 2**64
}
fn _5() -> Fixed {
    FixedTrait::new(5 * ONE_u128 , false) // 5 * 2**64
}
fn _10() -> Fixed {
    FixedTrait::new(10 * ONE_u128 , false) // 10 * 2**64
}
fn _16() -> Fixed {
    FixedTrait::new(16 * ONE_u128 , false) // 16 * 2**64
}


#[derive(Copy, Drop)]
struct Tuple {
  x: Fixed,
  y: Fixed
}


fn get_terrain_block(coord: VoxelCoord) -> felt252 {
    let biome = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome.span());
    _get_terrain_block(coord.x, coord.y, coord.z, height, biome)
}



fn _get_terrain_block(x: i32, y: i32, z: i32, height: i32, biome_values: Array<Fixed>) -> felt252 {

    let mut block_id = _Bedrock(y);
    if (block_id != 0) { return block_id; }

    block_id = _Water(y, height);
    if (block_id != 0) { return block_id; }

    block_id = _Air(y, height);
    if (block_id != 0) { return block_id; }

    let biome: u8 = get_max_biome(biome_values.span());

    block_id = _Diamond(x, y, z, height, biome);
    if (block_id != 0) { return block_id; }

    block_id = _Coal(x, y, z, height, biome);
    if (block_id != 0) { return block_id; }

    let distance_from_height = height - y;

    block_id = _Sand(y, height, biome, distance_from_height);
    if (block_id != 0) { return block_id; }

    block_id = _Snow(y, height, *biome_values[Biome::Mountains.into()]);
    if (block_id != 0) { return block_id; }

    block_id = _Grass(y, height, biome);
    if (block_id != 0) { return block_id; }

    block_id = _Stone(y, height, biome);
    if (block_id != 0) { return block_id; }

    block_id = _Clay(y, height, biome, distance_from_height);
    if (block_id != 0) { return block_id; }

    block_id = _Dirt(y, height, biome);
    if (block_id != 0) { return block_id; }

    block_id = _Structure(x, y, z, height, biome);
    if (block_id != 0) { return block_id; }

    block_id = _SmallPlant(x, y, z, height, biome);
    if (block_id != 0) { return block_id; }

    return AirID;
}



fn get_biome(x: i32, z: i32) -> Array<Fixed> {
    
    let heat: Fixed = simplex3::noise(
        Vec3Trait::new(
            FixedTrait::new(x.mag.into(), x.sign),
            FixedTrait::new(0, false),
            FixedTrait::new(z.mag.into(), z.sign),
        )
    );
    let humidity: Fixed = simplex3::noise(
        Vec3Trait::new(
            FixedTrait::new(z.mag.into(), z.sign),
            FixedTrait::new(x.mag.into(), x.sign),
            FixedTrait::new(5, false),
        )
    );

    let biome_vector = Tuple{ x: humidity, y: heat };

    let mut biome: Array<Fixed> = array![
        pos(
            ( _0_75() - euclidean(biome_vector, get_biome_vector(Biome::Mountains)) ) * _2()
        ),
        pos(
            ( _0_75() - euclidean(biome_vector, get_biome_vector(Biome::Desert)) ) * _2()
        ),
        pos(
            ( _0_75() - euclidean(biome_vector, get_biome_vector(Biome::Forest)) ) * _2()
        ),
        pos(
            ( _0_75() - euclidean(biome_vector, get_biome_vector(Biome::Savanna)) ) * _2()
        ),
    ];

    biome    
}

fn get_max_biome(biome_values: Span<Fixed>) -> u8 {
    let mut max_biome = _0();
    let mut biome: u8 = 0;
    let mut i: usize = 0;
    loop {
        if (i >= biome_values.len()) { 
            break; 
        }
        if (*biome_values[i] > max_biome) {
            max_biome = *biome_values[i];
            biome = i.try_into().unwrap();
        }
        i+=1;
    };
    biome
}



fn get_height(x: i32, z: i32, biome: Span<Fixed>) -> i32 {
    // Compute simplex height
    let simplex999 = simplex3::noise(
        Vec3Trait::new(
            FixedTrait::new(x.mag.into(), x.sign) - FixedTrait::new(550, false),
            FixedTrait::new(z.mag.into(), z.sign) + FixedTrait::new(550, false),
            FixedTrait::new(0, false),
        )
    );
    let continental_height = continentalness(simplex999);

    let mut terrain_height = simplex999 * _10();
    let simplex49 = simplex3::noise(
        Vec3Trait::new(
            FixedTrait::new(x.mag.into(), x.sign),
            FixedTrait::new(z.mag.into(), z.sign),
            FixedTrait::new(0, false),
        )
    );
    terrain_height += (simplex49 * _5());
    terrain_height += simplex3::noise(
        Vec3Trait::new(
            FixedTrait::new(x.mag.into(), x.sign),
            FixedTrait::new(z.mag.into(), z.sign),
            FixedTrait::new(0, false),
        )
    );
    terrain_height /= _16();

    // Compute biome height
    let mut height = *biome[Biome::Mountains.into()] * mountains(terrain_height);
    height += (*biome[Biome::Desert.into()] * desert(terrain_height));
    height += (*biome[Biome::Forest.into()] * forest(terrain_height));
    height += (*biome[Biome::Savanna.into()] * savanna(terrain_height));
    height /= (*biome[Biome::Mountains.into()] + *biome[Biome::Desert.into()] + *biome[Biome::Forest.into()] + *biome[Biome::Savanna.into()] + _1());

    height = continental_height + (height / _2());

    // Create valleys
    let valley = valleys(( (simplex3::noise(
        Vec3Trait::new(
            FixedTrait::new(x.mag.into(), x.sign),
            FixedTrait::new(z.mag.into(), z.sign),
            FixedTrait::new(0, false),
        )
    ) * _2()) + simplex49 ) / _3());
    
    height *= valley;

    // Scale height
    let value: Fixed = (height * FixedTrait::new(256, false)) / _1();
    let value: i32 = i32 {mag: value.mag.try_into().unwrap(), sign: value.sign};
    value - i32{mag: 128, sign: false}
}





fn get_biome_vector(biome: u8) -> Tuple {
    if (biome == Biome::Mountains){ 
        return Tuple{ x: _0(), y: _0() };
    }
    if (biome == Biome::Desert){ 
        return Tuple{ x: _0(), y: _1() };
    }
    if (biome == Biome::Forest){ 
        return Tuple{ x: _1(), y: _0() };
    }
    if (biome == Biome::Savanna){ 
        return Tuple{ x: _1(), y: _1() };
    }
    
    assert(false,'unknown biome');

    Tuple{ x: _0(), y: _0() } // for the compiler
}


fn get_coord_hash(x: i32, z: i32) -> u16 {
    let hash: felt252 = poseidon_hash_span(array![x.mag.into(), z.mag.into()].span());
    let hash_u256: u256 = hash.into();

    (hash_u256 % 1024).try_into().unwrap()
}

fn get_chunk_coord(x: i32, z: i32) -> (i32, i32) {
    return (x / STRUCTURE_CHUNK(), z / STRUCTURE_CHUNK() );
}



fn get_chunk_offset_and_height(x: i32, y: i32, z: i32) -> (i32, VoxelCoord) {
    let (chunk_x, chunk_z) = get_chunk_coord(x, z);
    let chunk_center_x = chunk_x * STRUCTURE_CHUNK() + STRUCTURE_CHUNK_CENTER();
    let chunk_center_z = chunk_z * STRUCTURE_CHUNK() + STRUCTURE_CHUNK_CENTER();
    let biome = get_biome(chunk_center_x, chunk_center_z);
    let height = get_height(chunk_center_x, chunk_center_z, biome.span());
    let offset = VoxelCoord {
        x: x - chunk_x * STRUCTURE_CHUNK(),
        y: y - height,
        z: z - chunk_z * STRUCTURE_CHUNK()
    };
    
    (height, offset)
}



fn get_biome_hash(x: i32, y: i32, biome: u8) -> u16 {
    get_coord_hash(x / i32{ mag: 300, sign: false } + y / i32{ mag: 300, sign: false }, i32 { mag: biome.into(), sign: false })
}

//////////////////////////////////////////////////////////////////////////////////////
// Utils
//////////////////////////////////////////////////////////////////////////////////////

// return Math.sqrt(Math.pow(a[0] - b[0], 2) + Math.pow(a[1] - b[1], 2));
fn euclidean(a: Tuple, b: Tuple) -> Fixed {
        let x = a.x - b.x;
        let x2 = x * x;

        let y = a.y - b.y;
        let y2 = y * y;

        let sum = x2 + y2;

        sum.sqrt()
    }


fn euclidean_vec(a: Array<Fixed>, b: Array<Fixed>) -> Fixed {
    euclidean(Tuple{ x: *a[0], y: *a[1] }, Tuple{ x: *b[0], y: *b[1] })
}


fn euclidean_raw(a0: Fixed, a1: Fixed, b0: Fixed, b1: Fixed) -> Fixed {
    euclidean(Tuple{ x: a0, y: a1 }, Tuple{ x: b0, y: b1 })
}


fn pos(x: Fixed) -> Fixed {
    if x < _0() { _0() } else { x }
}

fn coord_eq(a: VoxelCoord, b: Array<u8>) -> bool {
    a.x == i32 { mag: (*b[0]).into(), sign: false } &&
    a.y == i32 { mag: (*b[1]).into(), sign: false } &&
    a.z == i32 { mag: (*b[2]).into(), sign: false }
}


// //////////////////////////////////////////////////////////////////////////////////////
// // Spline functions
// //////////////////////////////////////////////////////////////////////////////////////


fn lerp(t: Fixed, a: Fixed, b: Fixed) -> Fixed {
    a + (t * (b - a))
}


fn apply_spline(x: Fixed, splines: Array<Tuple>) -> Fixed {
    let mut points: Array<Tuple> = array![];

    if splines.len() == 2 {
        points = array![*splines[0], *splines[1]];
    } else {
        let mut i = 0;
        loop {
            if (i >= splines.len()) { 
                break; 
            }
            let spline: Tuple = *splines[i];
            if (spline.x >= x) {
                points = array![*splines[i - 1], *splines[i]];
                break;
            }
            i+=1;
        };
    }

    let point0: Tuple = *points[0];
    let point1: Tuple = *points[1];
    let t = (x - point0.x) / (point1.x - point0.x);
    lerp(t, point0.y, point1.y)
}



fn continentalness(x: Fixed) -> Fixed {
    let splines = array![
        Tuple{ x: _0(), y: _0() },
        Tuple{ x: _0_5(), y: _0_5() },
        Tuple{ x: _1(), y: _0_5() },
    ];
    apply_spline(x, splines)
}


fn mountains(x: Fixed) -> Fixed {
    let splines = array![
        Tuple{ x: _0(), y: _0() },
        Tuple{ x: _0_3(), y: _0_4() },
        Tuple{ x: _0_6(), y: _2() },
        Tuple{ x: _1(), y: _4() },
    ];
    apply_spline(x, splines)
}


fn desert(x: Fixed) -> Fixed {
    let splines = array![
        Tuple{ x: _0(), y: _0() },
        Tuple{ x: _1(), y: _0_4() },
    ];
    apply_spline(x, splines)
}


fn forest(x: Fixed) -> Fixed {
    let splines = array![
        Tuple{ x: _0(), y: _0() },
        Tuple{ x: _1(), y: _0_5() },
    ];
    apply_spline(x, splines)
}


fn savanna(x: Fixed) -> Fixed {
    let splines = array![
        Tuple{ x: _0(), y: _0() },
        Tuple{ x: _1(), y: _0_4() },
    ];
    apply_spline(x, splines)
}


fn valleys(x: Fixed) -> Fixed {
    let splines = array![
        Tuple{ x: _0(), y: _1() },
        Tuple{ x: _0_45(), y: _1() },
        Tuple{ x: _0_49(), y: _0_9() },
        Tuple{ x: _0_499(), y: _0_8() },
        Tuple{ x: _0_501(), y: _0_8() },
        Tuple{ x: _0_51(), y: _0_9() },
        Tuple{ x: _0_55(), y: _1() },
        Tuple{ x: _1(), y: _1() },
    ];
    apply_spline(x, splines)
}








// //////////////////////////////////////////////////////////////////////////////////////
// // Block occurrence functions
// //////////////////////////////////////////////////////////////////////////////////////

fn Air(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    _Air(coord.y, height)
}



fn _Air(y: i32, height: i32) -> felt252 {
    if (y >= height + i32{mag: 2, sign: false} * STRUCTURE_CHUNK()) { 
        AirID 
    } else {
        0
    }

}






fn Water(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    _Water(coord.y, height)
}


fn _Water(y: i32, height: i32) -> felt252 {
    if (y < i32{ mag:0, sign: false} && y >= height) { WaterID }
    else {
        0
    }
}





fn Bedrock(coord: VoxelCoord) -> felt252 {
    _Bedrock(coord.y)
}

fn _Bedrock(y: i32) -> felt252 {
    if (y <= i32{ mag:63, sign: true}) { BedrockID }
    else {
        0
    }
}





fn Sand(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Sand(coord.y, height, biome, height - coord.y)
}


fn _Sand(y: i32, height: i32, biome: u8, distance_from_height: i32) -> felt252 {
    if (y >= height) { return 0; }

    if (biome == Biome::Desert && y >= i32{ mag:20, sign: true}) { return SandID; }

    if (y >= i32{ mag: 2, sign: false}) { return 0; }

    if (biome == Biome::Savanna && distance_from_height <= i32{ mag:4, sign: false}) { return SandID; }
    if (biome == Biome::Forest && distance_from_height <= i32{ mag:2, sign: false}) { return SandID; }

    0
}




fn Diamond(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Diamond(coord.x, coord.y, coord.z, height, biome)
}


fn _Diamond(x: i32, y: i32, z: i32, height: i32, biome: u8) -> felt252 {
    if (y >= height) { return 0; }

    if ((biome == Biome::Savanna || biome == Biome::Forest || biome == Biome::Forest) && y >= i32Impl::new(20, true)) { return 0; }

    let mut hash: u16 = get_coord_hash(x, z);
    if (hash > 10_u16) { return 0; }

    hash = get_coord_hash(y, x + z);
    if (hash <= 10_u16) { return DiamondID; }

    0
}







fn Coal(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Coal(coord.x, coord.y, coord.z, height, biome)
}


fn _Coal(x: i32, y: i32, z: i32, height: i32, biome: u8) -> felt252 {
    if (y >= height) { return 0; }

    if ((biome == Biome::Savanna || biome == Biome::Forest || biome == Biome::Forest) && y >= i32Impl::new(20,true)) { return 0; }

    let mut hash: u16 = get_coord_hash(x, z);
    if (hash <= 10_u16 || hash > 50_u16) { return 0; }

    hash = get_coord_hash(y, x + z);
    if (hash > 10_u16 && hash <= 50_u16) { return CoalID; }

    0

}







fn Snow(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    _Snow(coord.y, height, *biome_values[Biome::Mountains.into()])
}


fn _Snow(y: i32, height: i32, mountain_biome: Fixed) -> felt252 {
    if (y >= height) { return 0; }
    if ((y > i32{ mag:55, sign: false} || mountain_biome > _0_6()) && y == height - i32{ mag:1, sign: false}) { return SnowID; }

    0

}






fn Stone(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Stone(coord.y, height, biome)
}


fn _Stone(y: i32, height: i32, biome: u8) -> felt252 {
    if (y >= height) { return 0; }

    if ((biome == Biome::Savanna || biome == Biome::Forest || biome == Biome::Desert) && y >= i32{ mag:20, sign: true}) { return 0; }

    StoneID
}






fn Clay(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Clay(coord.y, height, biome, height - coord.y)
}



fn _Clay(y: i32, height: i32, biome: u8, distance_from_height: i32) -> felt252 {
    if (y >= height) { return 0; }
    if (biome == Biome::Savanna && y < i32Impl::new(2,false) && distance_from_height <= i32Impl::new(6,false)) { return ClayID; }

    0

}






fn Grass(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Grass(coord.y, height, biome)
}

fn _Grass(y: i32, height: i32, biome: u8) -> felt252 {
    if (y >= height) { return 0; }
    if (y < i32Impl::new(0,false)) { return 0; }

    if ((biome == Biome::Savanna || biome == Biome::Forest) && y == height - i32Impl::new(1,false)) { return GrassID; }
    if (biome == Biome::Mountains && y < i32Impl::new(40,false) && y == height - i32Impl::new(1,false)) { return GrassID; }

    0

}





fn Dirt(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Dirt(coord.y, height, biome)
}


fn _Dirt(y: i32, height: i32, biome: u8) -> felt252 {
    if (y >= height) { return 0; }
    if (biome == Biome::Savanna || biome == Biome::Forest) { return DirtID; }
    
    0

}





fn SmallPlant(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _SmallPlant(coord.x, coord.y, coord.z, height, biome)
}


fn _SmallPlant(x: i32, y: i32, z: i32, height: i32, biome: u8) -> felt252 {
    if (y != height) { return 0; }

    let hash = get_coord_hash(x, z);

    if (biome == Biome::Desert) {
        if (hash < 5) { return GreenFlowerID; }
        if (hash > 990) { return KelpID; }
    }

    if (biome == Biome::Savanna) {
        if (hash < 5) { return RedFlowerID; }
        if (hash < 10) { return OrangeFlowerID; }
        if (hash < 15) { return MagentaFlowerID; }
        if (hash < 20) { return LimeFlowerID; }
        if (hash < 25) { return PinkFlowerID; }
        if (hash < 30) { return CyanFlowerID; }
        if (hash < 35) { return PurpleFlowerID; }
        if (hash >= 900) { return GrassPlantID; }
    }

    if (biome == Biome::Forest) {
        if (hash < 5) { return BlueFlowerID; }
        if (hash < 10) { return LightGrayFlowerID; }
        if (hash < 15) { return GrassPlantID; }
    }

    if (biome == Biome::Mountains) {
        if (y > i32Impl::new(55,false) && hash < 5) { return GrayFlowerID; }
        if (y <= i32Impl::new(55,false) && hash < 10) { return LightBlueFlowerID; }
        if (y <= i32Impl::new(55,false) && hash < 15) { return BlackFlowerID; }
    }

    0

}





fn Structure(coord: VoxelCoord) -> felt252 {
    let biome_values = get_biome(coord.x, coord.z);
    let height = get_height(coord.x, coord.z, biome_values.span());
    let biome = get_max_biome(biome_values.span());
    _Structure(coord.x, coord.y, coord.z, height, biome)
}



fn _Structure(x: i32, y: i32, z: i32, height: i32, biome: u8) -> felt252 {
    if (y < height || y < i32 { mag:0, sign:false }) { return 0; }

    if (biome == Biome::Mountains || biome == Biome::Desert) { return 0; }

    let (chunk_x, chunk_z) = get_chunk_coord(x, z);
    let hash: u16 = get_coord_hash(chunk_x, chunk_z);

    if (biome == Biome::Savanna && hash < 50) {
        let (chunk_height, chunk_offset) = get_chunk_offset_and_height(x, y, z);
        if (chunk_height <= i32Impl::new(0,false)) { return 0; }
        let biome_hash: u16 = get_biome_hash(x, z, biome);
        return if hash < biome_hash / 40 { WoolTree(chunk_offset) } else { Tree(chunk_offset) };
    }

    if (biome == Biome::Forest && hash < 200) {
        let (chunk_height, chunk_offset) = get_chunk_offset_and_height(x, y, z);
        if (chunk_height <= i32Impl::new(0,false)) { return 0; }
        let biome_hash: u16 = get_biome_hash(x, z, biome);
        return if hash < biome_hash / 10 { WoolTree(chunk_offset) } else { Tree(chunk_offset) };
    }

    0

}


fn Tree(offset: VoxelCoord) -> felt252 {
    if (coord_eq(offset, array![3, 0, 3])) { return LogID; }
    if (coord_eq(offset, array![3, 1, 3])) { return LogID; }
    if (coord_eq(offset, array![3, 2, 3])) { return LogID; }
    if (coord_eq(offset, array![3, 3, 3])) { return LogID; }

    if (coord_eq(offset, array![2, 3, 3])) { return LeavesID; }
    if (coord_eq(offset, array![3, 3, 2])) { return LeavesID; }
    if (coord_eq(offset, array![4, 3, 3])) { return LeavesID; }
    if (coord_eq(offset, array![3, 3, 4])) { return LeavesID; }
    if (coord_eq(offset, array![2, 3, 2])) { return LeavesID; }
    if (coord_eq(offset, array![4, 3, 4])) { return LeavesID; }
    if (coord_eq(offset, array![2, 3, 4])) { return LeavesID; }
    if (coord_eq(offset, array![4, 3, 2])) { return LeavesID; }
    if (coord_eq(offset, array![2, 4, 3])) { return LeavesID; }
    if (coord_eq(offset, array![3, 4, 2])) { return LeavesID; }
    if (coord_eq(offset, array![4, 4, 3])) { return LeavesID; }
    if (coord_eq(offset, array![3, 4, 4])) { return LeavesID; }
    if (coord_eq(offset, array![3, 4, 3])) { return LeavesID; }
    0
}


fn WoolTree(offset: VoxelCoord) -> felt252 {
    if (coord_eq(offset, array![3, 0, 3])) { return LogID; }
    if (coord_eq(offset, array![3, 1, 3])) { return LogID; }
    if (coord_eq(offset, array![3, 2, 3])) { return LogID; }
    if (coord_eq(offset, array![3, 3, 3])) { return LogID; }

    if (coord_eq(offset, array![2, 2, 3])) { return WoolID; }
    if (coord_eq(offset, array![3, 2, 2])) { return WoolID; }
    if (coord_eq(offset, array![4, 2, 3])) { return WoolID; }
    if (coord_eq(offset, array![3, 2, 4])) { return WoolID; }
    if (coord_eq(offset, array![2, 3, 3])) { return WoolID; }
    if (coord_eq(offset, array![3, 3, 2])) { return WoolID; }
    if (coord_eq(offset, array![4, 3, 3])) { return WoolID; }
    if (coord_eq(offset, array![3, 3, 4])) { return WoolID; }
    if (coord_eq(offset, array![2, 3, 2])) { return WoolID; }
    if (coord_eq(offset, array![4, 3, 4])) { return WoolID; }
    if (coord_eq(offset, array![2, 3, 4])) { return WoolID; }
    if (coord_eq(offset, array![4, 3, 2])) { return WoolID; }
    if (coord_eq(offset, array![2, 4, 3])) { return WoolID; }
    if (coord_eq(offset, array![3, 4, 2])) { return WoolID; }
    if (coord_eq(offset, array![4, 4, 3])) { return WoolID; }
    if (coord_eq(offset, array![3, 4, 4])) { return WoolID; }
    if (coord_eq(offset, array![3, 4, 3])) { return WoolID; }

    0
}