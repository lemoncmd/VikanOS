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

struct MemoryMap {
  unsigned long long buffer_size;
  void* buffer;
  unsigned long long map_size;
  unsigned long long map_key;
  unsigned long long descriptor_size;
  uint32_t descriptor_version;
};

void main__kernel_main(struct FrameBufferConfig* frame_buffer_config, struct MemoryMap* memory_map);

void KernelMain(struct FrameBufferConfig* frame_buffer_config,
    struct MemoryMap* memory_map) {
  main__kernel_main(frame_buffer_config, memory_map);
}
