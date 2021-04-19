import graphic
import console
import mm
import usb

#include "newlib_support.h"
#include "asmfunc.h"
fn C.SetCSSS(cs u16, ss u16)
fn C.SetDSAll(value u16)

type Color = graphic.PixelColor

[noreturn]
fn halt() {
	for {
		asm amd64 {hlt}
	}
}

fn C.register_console_print_handler(&console.Console, fn(&console.Console, byteptr))

fn console_print_handler(mut c console.Console, s byteptr) {
	c.put_string(unsafe{s.vstring()})
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

	mut segment_settings := mm.SegmentSettings{}
	segment_settings.setup_segments()

	kernel_cs := 1 << 3
	kernel_ss := 2 << 3
	C.SetDSAll(0)
	C.SetCSSS(kernel_cs, kernel_ss)

	mut paging_settings := mm.PagingSettings{}
	paging_settings.setup_identity_page_table()

	mut memory_manager := mm.BitmapMemoryManager{}
	memory_manager.init()

	memory_map_base := u64(memory_map.buffer)
	mut available_end := u64(0)
	for i := memory_map_base; i < memory_map_base + memory_map.map_size; i += memory_map.descriptor_size {
		desc := &mm.MemoryDescriptor(voidptr(i))
		if available_end < u64(desc.physical_start) {
			memory_manager.mark_allocated(
				mm.FrameID(size_t(available_end / 4096)),
				(u64(desc.physical_start) - available_end) / 4096
			)
		}
		physical_end := u64(desc.physical_start) + desc.number_of_pages * 4096
		if mm.MemoryType(desc.memory_type).is_available() {
			available_end = physical_end
		} else {
			memory_manager.mark_allocated(
				mm.FrameID(desc.physical_start / size_t(4096)),
				desc.number_of_pages * 4096 / 4096
			)
		}
	}
	memory_manager.set_memory_range(mm.FrameID(size_t(1)), mm.FrameID(size_t(available_end / 4096)))

	memory_manager.init_heap() or {
		halt()
	}
	for i in 0..5 {
		println('hoge$i')
	}
/*	cons.put_string('hogehgoeee')
	println('auga')
	println('hoge')*/
	halt()
	println('hoge')
}
