import graphic
import console
import mm

#include "newlib_support.h"

type Color = graphic.PixelColor

[noreturn]
fn halt() {
	for {
		asm amd64 {hlt}
	}
}

fn C.register_console_print_handler(&console.Console, fn(&console.Console, byteptr))

fn console_print_handler(mut c console.Console, s byteptr) {
	c.put_string(s.vstring())
}

fn kernel_main(frame_buffer_config_ref &graphic.FrameBufferConfig,
	memory_map_ref &mm.MemoryMap) {
	frame_buffer_config := *frame_buffer_config_ref
	memory_map := *memory_map_ref
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
	C.register_console_print_handler(&cons, &console_print_handler)
	println('hgoe')
/*	cons.put_string('hogehgoeee')
	println('auga')
	println('hoge')*/
	halt()
	println('hoge')
}
