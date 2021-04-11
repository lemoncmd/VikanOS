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

_Alignas(16) uint8_t kernel_main_stack[1024 * 1024];
_Alignas(4096) uint64_t pml4_table[512];
_Alignas(4096) uint64_t pdp_table[512];
_Alignas(4096) uint64_t page_directory[64][512];

void KernelMainNewStack(struct FrameBufferConfig* frame_buffer_config,
    struct MemoryMap* memory_map) {
  main__kernel_main(frame_buffer_config, memory_map);
}
