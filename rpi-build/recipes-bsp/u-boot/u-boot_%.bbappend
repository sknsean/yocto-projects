do_configure_append() {
	echo "#define CONFIG_SYS_BOOTM_LEN 0x1400000" >> ${S}/include/configs/rpi.h
}
