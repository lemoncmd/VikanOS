module mm

pub struct MemoryMap {
pub:
	buffer_size u64
	buffer voidptr
	map_size u64
	map_key u64
	descriptor_size u64
	descriptor_version u32
}

struct MemoryDescriptor {
pub:
	memory_type u32
	physical_start size_t
	virtual_start size_t
	number_of_pages u64
	attribute u64
}

enum MemoryType {
	reserved_memory_type
	loader_code
	loader_data
	boot_services_code
	boot_services_data
	runtime_services_code
	runtime_services_data
	conventional_memory
	unusable_memory
	acpi_reclaim_memory
	acpi_memory_nvs
	memory_mapped_io
	memory_mapped_io_port_space
	pal_code
	persistent_memory
	max_memory_type
}

pub fn (t MemoryType) is_available() bool {
	return t in [.boot_services_code, .boot_services_data, .conventional_memory]
}
