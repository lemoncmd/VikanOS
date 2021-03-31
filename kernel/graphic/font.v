module graphic

#include "graphic/font.h"

fn get_font(c rune) byteptr {
	index := 16 * u32(c)
	if index >= u32(&C._binary_hankaku_bin_size) {
		return byteptr(0)
	}
	return unsafe { &C._binary_hankaku_bin_start + index }
}

pub fn (config &FrameBufferConfig) write_ascii(x int, y int, c rune, color &PixelColor) {
	font := get_font(c)
	if font == byteptr(0) {
		return
	}
	for dy in 0..16 {
		for dx in 0..8 {
			if (unsafe { font[dy] } << dx) & 0x80 != 0 {
				config.write_pixel(x + dx, y + dy, color)
			}
		}
	}
}

