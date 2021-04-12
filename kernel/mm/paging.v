module mm

#include "entry.h"
#include "asmfunc.h"
fn C.SetCR3(value u64)

type Arr_table = [512]u64
type Arr_page = [64][512]u64

pub struct PagingSettings {
mut:
	pml4_table &Arr_table = 0 // &[512]u64
	pdp_table &Arr_table = 0 // &[512]u64
	page_directory &Arr_page = 0 // &[64][512]u64
}

pub fn (mut p PagingSettings) setup_identity_page_table() {
	p.pml4_table = voidptr(C.pml4_table)
	p.pdp_table = voidptr(C.pdp_table)
	p.page_directory = voidptr(C.page_directory)
	(*p.pml4_table)[0] = u64(&(*p.pdp_table)[0]) | 0x003
	for i_pdpt in 0..64 {
		(*p.pdp_table)[i_pdpt] = u64(&(*p.page_directory)[i_pdpt]) | 0x003
		for i_pd in 0..512 {
			(*p.page_directory)[i_pdpt][i_pd] = u64(i_pdpt) * (4096 * 512 * 512) + u64(i_pd) * (4096 * 512) | 0x083
		}
	}
	C.SetCR3(u64(&(*p.pml4_table)[0]))
}
