
use orion::numbers::signed_integer::i32::{i32, i32Impl};

use core::traits::Into;
use core::poseidon::poseidon_hash_span;
use core::array::{ArrayTrait, SpanTrait};


#[derive(Copy, Drop, Serde)]
struct Coord {
    x: i32,
    y: i32
}

#[derive(Copy, Drop, Serde)]
struct VoxelCoord {
    x: i32,
    y: i32,
    z: i32
}

trait VoxelCoordTrait {
    fn hash(self: VoxelCoord) -> felt252;
}

impl VoxelCoordImpl of VoxelCoordTrait {
    fn hash(self: VoxelCoord) -> felt252 {
        poseidon_hash_span(
            array![
                self.x.into(),
                self.y.into(),
                self.z.into()
            ].span()
        )
    }
}

#[derive(Model, Copy, Drop, Serde)]
struct Position {
    #[key]
    id: u256,
    x: u32,
    x_neg: bool,
    y: u32,
    y_neg: bool,
    z: u32,
    z_neg: bool
}

impl PositionIntoVoxelCoord of Into<Position, VoxelCoord> {
    fn into(self: Position) -> VoxelCoord {
        return VoxelCoord {
            x: i32Impl::new(self.x, self.x_neg),
            y: i32Impl::new(self.y, self.y_neg),
            z: i32Impl::new(self.z, self.z_neg)
        };
    }
}


#[derive(Model, Copy, Drop, Serde)]
struct PositionOccupation {
    #[key]
    hash: felt252,
    occupied_by_non_air: u256,
    occupied_by_air: u256
}