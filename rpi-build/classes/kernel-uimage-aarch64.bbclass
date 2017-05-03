# Based on
# poky-releases/2.0.2/poky/meta/classes/kernel-uimage.bbclass
#
# The yocto uboot classes do not work well with arm64 kernel builds. Yocto builds
# uImages by either using uImage as the make target, if KEEPUIMAGE is used, or by
# running mkimage on the vmlinux, in which case yocto sets the kernel make target
# to zImage.
#
# For arm64 things are different: there are no uImage or zImage build targets in the
# kernel, and the kernel image format is not vmlinux, but the arm64 specific "Image"
# format, described in https://www.kernel.org/doc/Documentation/arm64/booting.txt
# The make target for arm64 images may be "Image" or "Image.gz", but if that is used,
# the standard yocto classes will not create an uboot image.
inherit kernel-uboot

python __anonymous () {
    if "uImage" in (d.getVar('KERNEL_IMAGETYPES') or "").split():
        depends = d.getVar("DEPENDS")
        depends = "%s u-boot-mkimage-native" % depends
        d.setVar("DEPENDS", depends)

        # Override KERNEL_IMAGETYPE_FOR_MAKE variable, which is internal
        # to kernel.bbclass . We override the variable here, since the
        # kernel aarch64 build system does not include uImage targets.
        d.setVar("KERNEL_IMAGETYPE_FOR_MAKE", "Image.gz")
}

do_uboot_mkimage() {
    if test "x${KERNEL_IMAGETYPE}" = "xuImage" ; then
	uboot-mkimage -A ${UBOOT_ARCH} -O linux -T kernel -C gzip -a ${UBOOT_LOADADDRESS} -e ${UBOOT_ENTRYPOINT} -n "${DISTRO_NAME}/${PV}/${MACHINE}" -d ${B}/arch/${ARCH}/boot/${KERNEL_IMAGETYPE_FOR_MAKE} ${B}/arch/${ARCH}/boot/uImage
    fi
}

addtask uboot_mkimage before do_install after do_compile
