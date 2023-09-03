use dojo::serde::SerdeLen;

use orion::numbers::signed_integer::i32::{i32};

impl SerdeLeni32 of SerdeLen<i32> {
    fn len() -> usize {
        2
    }
}

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

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Position {
    #[key]
    id: u256,
    x: i32,
    y: i32,
    z: i32
}


#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct PositionOccupation {
    #[key]
    x: i32,
    #[key]
    y: i32,
    #[key]
    z: i32,
    occupied_by_non_air: u256,
    occupied_by_air: u256
}