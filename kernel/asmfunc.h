#include "stdint.h"

void LoadGDT(uint16_t limit, uint64_t offset);
void SetCSSS(uint16_t cs, uint16_t ss);
void SetDSAll(uint16_t value);
