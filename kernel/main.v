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

fn (config FrameBufferConfig) write_pixel(x int, y int, c PixelColor) ? {
	pixel_position := int(config.pixels_per_scan_line) * y + x
	if int(config.pixel_format) !in [0, 1] {
		return error('pixel format is wrong')
	}
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
	return
}

fn kernel_main(frame_buffer_config &FrameBufferConfig) {
	for x in 0..frame_buffer_config.horizontal_resolution {
		for y in 0..frame_buffer_config.vertical_resolution {
			frame_buffer_config.write_pixel(x, y, PixelColor{255, 255, 255}) or {panic(err)}
		}
	}
	for x in 0..200 {
		for y in 0..100 {
			frame_buffer_config.write_pixel(100 + x, 100 + y, PixelColor{0, 255, 0}) or {panic(err)}
		}
	}
	for {
		asm amd64 {hlt}
	}
	println('hoge')
}
