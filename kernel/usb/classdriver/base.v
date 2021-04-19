module classdriver

import usb

pub struct ClassDriver {
	dev &usb.Device
}
