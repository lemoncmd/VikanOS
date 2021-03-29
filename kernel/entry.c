#include <stdint.h>

enum PixelFormat {
  kPixelRGBResv8BitPerColor,
  kPixelBGRResv8BitPerColor,
};

struct FrameBufferConfig {
  uint8_t* frame_buffer;
  uint32_t pixels_per_scan_line;
  uint32_t horizontal_resolution;
  uint32_t vertical_resolution;
  enum PixelFormat pixel_format;
};

void main__kernel_main(struct FrameBufferConfig* frame_buffer_config);

void KernelMain(struct FrameBufferConfig* frame_buffer_config) {
  main__kernel_main(frame_buffer_config);
}
