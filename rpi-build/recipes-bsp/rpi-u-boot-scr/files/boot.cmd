test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

setenv bootargs
for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${bootargs}" != "x"; then
    # skip remaining slots
  elif test "x${BOOT_SLOT}" = "xA"; then
    if test ${BOOT_A_LEFT} -gt 0; then
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      echo "Found valid slot A, ${BOOT_A_LEFT} attempts remaining"
      setenv load_kernel "ext4load mmc 0:2 ${kernel_addr_r} /boot/uImage"
      setenv load_fdt "ext4load mmc 0:2 ${fdt_addr} /boot/${fdtfile}"
      setenv bootargs "${default_bootargs} root=/dev/mmcblk0p2 rauc.slot=A"
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if test ${BOOT_B_LEFT} -gt 0; then
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      echo "Found valid slot B, ${BOOT_B_LEFT} attempts remaining"
      setenv load_kernel "ext4load mmc 0:3 ${kernel_addr_r} /boot/uImage"
      setenv load_fdt "ext4load mmc 0:3 ${fdt_addr} /boot/${fdtfile}"
      setenv bootargs "${default_bootargs} root=/dev/mmcblk0p3 rauc.slot=B"
    fi
  fi
done

if test -n "${bootargs}"; then
  saveenv
else
  echo "No vaild slot found, resetting tries to 3"
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  saveenv
  reset
fi

echo "Loading kernel"
run load_kernel
#run load_fdt
echo " Starting kernel"
bootm ${kernel_addr_r} - ${fdt_addr}
