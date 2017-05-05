FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fw_env.config"

do_install () {
	install -d ${D}${base_sbindir}
	install -d ${D}${sysconfdir}
	install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_printenv
	install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_setenv
	install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}
