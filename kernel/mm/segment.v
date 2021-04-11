module mm

import bitfield
struct LocalBitField{
mut:
	size int
	field []u32
}
fn new_bitfield_from_array(size int, arr []u32) bitfield.BitField {
	lbf := LocalBitField{
		size: size,
		field: arr
	}
	return *unsafe{&bitfield.BitField(&lbf)}
}

#include "asmfunc.h"
fn C.LoadGDT(limit u16, offset u64)

pub struct SegmentSettings {
mut:
	gdt [3]u64
}

enum DescriptorType {
	upper8bytes = 0
//	ldt = 2
	tss_available = 9
	tss_busy = 11
	call_gate = 12
	interrupt_gate = 14
	trap_gate = 15
	read_write = 2
	execute_read = 10
}

struct SegmentDescriptorConfig {
	is_data_segment bool
	limit_low u64
	base_low u64
	base_middle u64
	typ DescriptorType
	system_segment u64
	descriptor_privilege_level u64
	present u64
	limit_high u64
	available u64
	long_mode u64
	default_operation_size u64
	granularity u64
	base_high u64
}

fn segment_descriptor_factory(val u64, s SegmentDescriptorConfig) u64 {
	arr := [u32(0), 0]
	mut output := new_bitfield_from_array(64, arr)
	output.insert_lowest_bits_first(0, 64, val)
	if !s.is_data_segment {
		output.insert_lowest_bits_first(0, 16, s.limit_low)
		output.insert_lowest_bits_first(16, 16, s.base_low)
		output.insert_lowest_bits_first(32, 8, s.base_middle)
		output.insert_lowest_bits_first(40, 4, int(s.typ))
		output.insert_lowest_bits_first(44, 1, s.system_segment)
		output.insert_lowest_bits_first(45, 2, s.descriptor_privilege_level)
		output.insert_lowest_bits_first(47, 1, s.present)
		output.insert_lowest_bits_first(48, 4, s.limit_high)
		output.insert_lowest_bits_first(52, 1, s.available)
		output.insert_lowest_bits_first(53, 1, s.long_mode)
		output.insert_lowest_bits_first(55, 1, s.granularity)
	}
	output.insert_lowest_bits_first(54, 1, s.default_operation_size)
	output.insert_lowest_bits_first(56, 8, s.base_high)
	return output.extract_lowest_bits_first(0, 64)
}

fn set_code_segment(typ DescriptorType, descriptor_privilege_level u32, base u32, limit u32) u64 {
	return segment_descriptor_factory(0, {
		is_data_segment: false,

		base_low: base & 0xffff,
		base_middle: (base >> 16) & 0xff,
		base_high: (base >> 24) & 0xff,

		limit_low: limit & 0xffff,
		limit_high: (limit >> 16) & 0xffff,

		typ: typ,
		system_segment: 1,
		descriptor_privilege_level: descriptor_privilege_level,
		present: 1,
		available: 0,
		long_mode: 1,
		default_operation_size: 0,
		granularity: 1
	})
}

fn set_data_segment(typ DescriptorType, descriptor_privilege_level u32, base u32, limit u32) u64 {
	desc := set_code_segment(typ, descriptor_privilege_level, base, limit)
	return segment_descriptor_factory(desc, {
		is_data_segment: true,

		long_mode: 0,
		default_operation_size: 1
	})
}

pub fn (mut s SegmentSettings) setup_segments() {
	s.gdt[0] = 0
	s.gdt[1] = set_code_segment(.execute_read, 0, 0, 0xfffff)
	s.gdt[2] = set_data_segment(.read_write, 0, 0, 0xfffff)
	C.LoadGDT(sizeof(s.gdt) - 1, &s.gdt[0])
}
