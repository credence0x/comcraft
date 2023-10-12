use comcraft::constants::CHUNK;
use comcraft::models::position::{Coord, VoxelCoord};


mod u64Helpers {
    fn fpow(x: u64, n: u64) -> u64 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * fpow(x * x, n / 2)
        } else {
            fpow(x * x, n / 2)
        }
    }

    fn shl(x: u64, n: u64) -> u64 {
        x * fpow(2, n)
    }
}



mod u256Helpers {
    fn fpow(x: u256, n: u256) -> u256 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * fpow(x * x, n / 2)
        } else {
            fpow(x * x, n / 2)
        }
    }

    fn shl(x: u256, n: u256) -> u256 {
        x * fpow(2, n)
    }
}


fn get_chunk_coord(coord: VoxelCoord) -> Coord  {
  Coord {
    x: coord.x / CHUNK(),
    y: coord.z / CHUNK(), // yes y == coord.z
  }
}

