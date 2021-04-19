module usb

import bitfield

[packed]
struct DeviceDescriptor {
	length byte
	descriptor_type byte
	usb_release u16
	device_class byte
	device_sub_class byte
	device_protocol byte
	max_packet_size byte
	vendor_id u16
	product_id u16
	device_release u16
	manufacturer byte
	product byte
	serial_number byte
	num_configurations byte
}

[packed]
struct ConfigurationDescriptor {
	length byte
	descriptor_type byte
	total_length u16
	num_interfaces byte
	configuration_value byte
	configuration_id byte
	attributes byte
	max_power byte
}

[packed]
struct InterfaceDescriptor {
	length byte
	descriptor_type byte
	interface_number byte
	alternate_setting byte
	num_endpoints byte
	interface_class byte
	interface_sub_class byte
	interface_protocol byte
	interface_id byte
}

[packed]
struct EndpointDescriptor {
	length byte
	descriptor_type byte
	endpoint_address byte // number:4 3 dir_in:1
	attributes byte // transfer_type:2 sync_type:2 usage_type:2 2
	max_packet_size u16
	interval byte
}

[packed]
struct HIDDescriptor {
	length byte
	descriptor_type byte
	hid_release u16
	country_code byte
	num_descriptors byte
}

[packed]
struct ClassDescriptor {
	length byte
	descriptor_type byte
}

type Descriptor = DeviceDescriptor | ConfigurationDescriptor |
	InterfaceDescriptor | EndpointDescriptor | HIDDescriptor

fn get_descriptor(desc_data &byte) ?Descriptor {
	desc_class := &ClassDescriptor(desc_data)
	match desc_class.descriptor_type {
		1 { return *&DeviceDescriptor(desc_data) }
		2 { return *&ConfigurationDescriptor(desc_data) }
		4 { return *&InterfaceDescriptor(desc_data) }
		5 { return *&EndpointDescriptor(desc_data) }
		33 { return *&HIDDescriptor(desc_data) }
		else { return error('not supported descriptor type') }
	}
}

fn (e EndpointDescriptor) read_endpoint_address() (byte, byte) {
	field := bitfield.from_bytes_lowest_bits_first([e.endpoint_address])
	return
		byte(field.extract_lowest_bits_first(0, 4)),
		byte(field.extract_lowest_bits_first(7, 1))
}

fn (e EndpointDescriptor) read_attributes() (byte, byte, byte) {
	field := bitfield.from_bytes_lowest_bits_first([e.attributes])
	return
		byte(field.extract_lowest_bits_first(0, 2)),
		byte(field.extract_lowest_bits_first(2, 2)),
		byte(field.extract_lowest_bits_first(4, 2))
}
