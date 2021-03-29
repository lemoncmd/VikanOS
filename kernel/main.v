fn kernel_main() {
	for {
		asm amd64 {hlt}
	}
}
