enum PixelFormat {
	rgb bgr
}

struct FrameBufferConfig {
	frame_buffer &byte
	pixels_per_scan_line u32
	horizontal_resolution u32
	vertical_resolution u32
	pixel_format PixelFormat
}

struct PixelColor {
	r byte
	g byte
	b byte
}

fn (config &FrameBufferConfig) write_pixel(x int, y int, c &PixelColor) {
	pixel_position := int(config.pixels_per_scan_line) * y + x
	unsafe {
		mut p := &config.frame_buffer[4 * pixel_position]
		match config.pixel_format {
			.rgb {
				p[0] = c.r
				p[1] = c.g
				p[2] = c.b
			}
			.bgr {
				p[0] = c.b
				p[1] = c.g
				p[2] = c.r
			}
		}
	}
	return
}

[noreturn]
fn halt() {
	for {
		asm amd64 {hlt}
	}
}

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

fn (config &FrameBufferConfig) write_ascii(x int, y int, c rune, color &PixelColor) {
	if c != `A` { return }
	for dy in 0..16 {
		for dx in 0..8 {
			if (font_a[dy] << dx) & 0x80 != 0 {
				config.write_pixel(x + dx, y + dy, color)
			}
		}
	}
}

fn kernel_main(frame_buffer_config &FrameBufferConfig) {
	if int(frame_buffer_config.pixel_format) !in [0, 1] {
		halt()
	}
	for x in 0..frame_buffer_config.horizontal_resolution {
		for y in 0..frame_buffer_config.vertical_resolution {
			frame_buffer_config.write_pixel(x, y, PixelColor{255, 255, 255})
		}
	}
	for x in 0..200 {
		for y in 0..100 {
			frame_buffer_config.write_pixel(100 + x, 100 + y, PixelColor{0, 255, 0})
		}
	}
	frame_buffer_config.write_ascii(50, 50, `A`, PixelColor{0, 0, 0})
	frame_buffer_config.write_ascii(58, 50, `A`, PixelColor{0, 0, 0})
	halt()
	println('hoge')
}
