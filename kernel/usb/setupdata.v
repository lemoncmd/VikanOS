module usb

[packed]
struct SetupData {
	request_type byte // recipient:5 type:2 direction:1
	request byte
	value u16
	index u16
	length u16
}
