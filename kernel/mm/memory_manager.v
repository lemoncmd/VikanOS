module mm

type FrameID = size_t

fn (f FrameID) frame() voidptr {
	return voidptr(u64(f) * 4 * 1024)
}

type AllocMap = [524288]u64

pub struct BitmapMemoryManager {
mut:
	alloc_map &AllocMap = 0
	range_begin FrameID
	range_end FrameID
}

pub fn (mut b BitmapMemoryManager) init() {
	b.alloc_map = &AllocMap(voidptr(&C.memory_alloc_map))
}

fn (b BitmapMemoryManager) get_bit(frame FrameID) bool {
	line_index := u64(frame) / 64
	bit_index := u64(frame) % 64

	return ((*b.alloc_map)[line_index] & (1 << bit_index)) != 0
}

fn (mut b BitmapMemoryManager) set_bit(frame FrameID, allocated bool) {
	line_index := u64(frame) / 64
	bit_index := u64(frame) % 64

	if allocated {
		(*b.alloc_map)[line_index] |= (1 << bit_index)
	} else {
		(*b.alloc_map)[line_index] &= ~(1 << bit_index)
	}
}

pub fn (mut b BitmapMemoryManager) set_memory_range(range_begin FrameID, range_end FrameID) {
	b.range_begin = range_begin
	b.range_end = range_end
}

pub fn (mut b BitmapMemoryManager) mark_allocated(start_frame FrameID, num_frames u64) {
	for i in 0..num_frames {
		b.set_bit(FrameID(size_t(start_frame) + size_t(i)), true)
	}
}

pub fn (mut b BitmapMemoryManager) allocate(num_frames u64) ?FrameID {
	mut start_frame_id := u64(b.range_begin)
	for {
		mut size := u64(0)
		for ; size < num_frames; size++ {
			if start_frame_id + size >= u64(b.range_end) {
				return error("no enough memory")
			}
			if b.get_bit(FrameID(size_t(start_frame_id + size))) {
				break
			}
		}
		if size == num_frames {
			b.mark_allocated(FrameID(size_t(start_frame_id)), num_frames)
			return FrameID(size_t(start_frame_id))
		}
		start_frame_id += size + 1
	}
	return error("can't reach here")
}

pub fn (mut b BitmapMemoryManager) free(start_frame FrameID, num_frames u64) {
	for i in 0..num_frames {
		b.set_bit(FrameID(size_t(start_frame) + size_t(i)), false)
	}
}
