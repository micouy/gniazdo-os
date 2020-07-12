#![feature(asm)]
#![no_std]
#![no_main]

use core::{panic::PanicInfo, ops::BitOr};

const VGA_MEMORY: *mut u16 = 0xb8000 as *mut u16;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[repr(u8)]
#[derive(Copy, Clone)]
pub enum Color {
    Black = 0x0,
    Blue = 0x1,
    Green = 0x2,
    Cyan = 0x3,
    Red = 0x4,
    Magenta = 0x5,
    Brown = 0x6,
    LightGray = 0x7,
    DarkGray = 0x8,
    LightBlue = 0x9,
    LightGreen = 0xa,
    LightCyan = 0xb,
    LightRed = 0xc,
    Pink = 0xd,
    Yellow = 0xe,
    White = 0xf,
}

#[repr(C)]
#[derive(Copy, Clone)]
pub struct Style {
    pub bg: Color,
    pub fg: Color,
}

impl Into<u8> for Style {
    fn into(self) -> u8 {
        ((self.bg as u8) << 4) | (self.fg as u8)
    }
}

impl Color {
    fn on(self, bg: Color) -> Style {
        Style { fg: self, bg }
    }
}

pub struct Cell {
    pub style: Style,
    pub symbol: u8,
}

impl Into<u16> for Cell {
    fn into(self) -> u16 {
        let style = (Into::<u8>::into(self.style) as u16) << 8;
        let val = style | self.symbol as u16;

        val
    }
}

struct Video {
    cursor: u32,
}

impl Video {
    fn new() -> Self {
        Self { cursor: 0 }
    }

    fn print(&mut self, s: &str, style: Style) {
        unsafe {
            for (i, c) in s.bytes().enumerate() {
                let cell = Cell { style, symbol: c };
                *(VGA_MEMORY.offset(self.cursor as isize)) = cell.into();
                self.cursor += 1;
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    let mut video = Video::new();
    use Color::*;
    video.print("what if we kissed?????? jk LOL... unless???", White.on(Pink));

    loop {}
}
