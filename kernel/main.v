import graphic
import console

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
	for x in 0..200 {
		for y in 0..100 {
			frame_buffer_config.write_pixel(100 + x, 100 + y, Color{0, 255, 0})
		}
	}
	mut cons := console.new_console(frame_buffer_config, Color{0, 0, 0}, Color{255, 255, 255})
	cons.put_string('hogeeehoge')
	halt()
	println('hoge')
}
