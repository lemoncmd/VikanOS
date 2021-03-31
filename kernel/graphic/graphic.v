module graphic

enum PixelFormat {
	rgb bgr
}

struct FrameBufferConfig {
pub:
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

pub fn (config &FrameBufferConfig) write_pixel(x int, y int, c &PixelColor) {
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
