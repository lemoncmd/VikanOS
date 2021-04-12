#pragma once

#include <stdint.h>

extern uint64_t pml4_table[512];
extern uint64_t pdp_table[512];
extern uint64_t page_directory[64][512];
extern uint64_t memory_alloc_map[524288];

typedef uint64_t Array_fixed_Array_fixed_u64_512_64[64][512];
