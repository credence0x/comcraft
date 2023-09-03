use orion::numbers::signed_integer::i32::{i32, i32Impl};

// Terrain
mod Biome {
  const Mountains: u8 = 0;
  const Desert: u8 = 1;
  const Forest: u8 = 2;
  const Savanna: u8 = 3;
}


const GodID: felt252 = 0x60D;

fn STRUCTURE_CHUNK() -> i32 {
    i32Impl::new(5, false)
}

fn STRUCTURE_CHUNK_CENTER() -> i32 {
    i32Impl::new(3, false) // STRUCTURE_CHUNK / 2 + 1
}

fn CHUNK() -> i32 {
    i32Impl::new(16, false)
}
