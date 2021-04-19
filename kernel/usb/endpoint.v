module usb

enum EndpointType {
	control
	isochronous
	bulk
	interrupt
}

struct EndpointID {
	addr int
}

struct EndpointConfig {
	ep_id EndpointID
	ep_type EndpointType
	max_packet_size int
	interval int
}

fn (d EndpointDescriptor) make_ep_config() EndpointConfig {
	number, dir_in := d.read_endpoint_address()
	transfer_type, _, _ := d.read_attributes()
	return EndpointConfig{
		ep_id: new_endpoint_id(number, dir_in == 1),
		ep_type: EndpointType(transfer_type),
		max_packet_size: d.max_packet_size,
		interval: d.interval
	}
}

fn new_endpoint_id(ep_num int, dir_in bool) EndpointID {
	return EndpointID{ep_num << 1 | int(dir_in)}
}
