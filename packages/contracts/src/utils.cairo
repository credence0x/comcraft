use comcraft::constants::CHUNK;
use comcraft::components::position::{Position2D, Position3D};


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


fn get_chunk_coord(coord: Position3D) -> Position2D  {
  Position2D {
    x: coord.x / CHUNK(),
    y: coord.z / CHUNK(), // yes y == coord.z
  }
}

