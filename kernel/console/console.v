module console

import graphic

pub struct Console {
	config &graphic.FrameBufferConfig
	fg_color graphic.PixelColor
	bg_color graphic.PixelColor
mut:
	buf [25]string
	cursor_row int
	cursor_col int
pub:
	rows int = 25
	cols int = 80
}

pub fn new_console(config &graphic.FrameBufferConfig,
	fg_color graphic.PixelColor, bg_color graphic.PixelColor) Console {
	return Console{
		config: config
		fg_color: fg_color
		bg_color: bg_color
		buf: [25]string{init: ''}
		cursor_row: 0
		cursor_col: 0
	}
}

fn (mut c Console) new_line() {
	c.cursor_col = 0
	if c.cursor_row < c.rows - 1 {
		c.cursor_row++
	} else {
		for y in 0..16*c.rows {
			for x in 0..8*c.cols {
				c.config.write_pixel(x, y, c.bg_color)
			}
		}
		for row in 0..c.rows-1 {
			c.buf[row] = c.buf[row+1]
			c.config.write_string(0, 16 * row, c.buf[row], c.fg_color)
		}
		c.buf[c.rows - 1] = ''
	}
}

pub fn (mut c Console) put_string(s string) {
	for ch in s {
		if ch == `\n` {
			c.new_line()
		} else if c.cursor_col < c.cols - 1 {
			c.config.write_ascii(8 * c.cursor_col, 16 * c.cursor_row, ch, c.fg_color)
			c.buf[c.cursor_row] = '${c.buf[c.cursor_row]}$ch'
			c.cursor_col++
		}
	}
}
