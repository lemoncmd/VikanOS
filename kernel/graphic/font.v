module graphic

const font_a = [
	0b00000000,
	0b00011000,
	0b00011000,
	0b00011000,
	0b00011000,
	0b00100100,
	0b00100100,
	0b00100100,
	0b00100100,
	0b01111110,
	0b01000010,
	0b01000010,
	0b01000010,
	0b11100111,
	0b00000000,
	0b00000000,
]

pub fn (config &FrameBufferConfig) write_ascii(x int, y int, c rune, color &PixelColor) {
	if c != `A` { return }
	for dy in 0..16 {
		for dx in 0..8 {
			if (font_a[dy] << dx) & 0x80 != 0 {
				config.write_pixel(x + dx, y + dy, color)
			}
		}
	}
}

