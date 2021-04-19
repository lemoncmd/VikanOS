module usb

struct Device {
	class_drivers [16]ClassDriver
	buf [256]byte
	num_configurations byte
	config_index byte
	is_initialized bool
	initialize_phase int
	ep_configs [16]EndpointConfig
	num_ep_configs int
	event_waiters map[u64]SetupData
}
