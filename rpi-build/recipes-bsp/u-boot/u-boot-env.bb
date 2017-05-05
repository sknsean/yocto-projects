DESCRIPTION = "RPI uboot env"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://uboot.env"

inherit deploy

do_deploy() {
    cp ${WORKDIR}/uboot.env ${DEPLOYDIR}/
}

addtask deploy before do_package after do_install
