import graphic

type Color = graphic.PixelColor

[noreturn]
fn halt() {
	for {
		asm amd64 {hlt}
	}
}

fn kernel_main(frame_buffer_config &graphic.FrameBufferConfig) {
	if int(frame_buffer_config.pixel_format) !in [0, 1] {
		halt()
	}
	for x in 0..frame_buffer_config.horizontal_resolution {
		for y in 0..frame_buffer_config.vertical_resolution {
			frame_buffer_config.write_pixel(x, y, Color{255, 255, 255})
		}
	}
	for x in 0..50 {
		frame_buffer_config.write_ascii(x * 8, 50, `A` + x, Color{0, 0, 0})
	}
	for x in 0..200 {
		for y in 0..100 {
			frame_buffer_config.write_pixel(100 + x, 100 + y, Color{0, 255, 0})
		}
	}
	halt()
	println('hoge')
}
