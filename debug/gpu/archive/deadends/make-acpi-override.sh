#!/bin/bash
# Installs the PERMANENT solution: a patched NvdTable through the kernel's
# "ACPI table upgrade via initrd" mechanism. The patch closes the NVPCF gate
# (_DSM no longer hands the GSP the broken 15/20 W limit table), so the card always
# lives on vBIOS defaults (35 W), and the race with the EC stops mattering.
#
#   sudo ./make-acpi-override.sh
#
# Creates:
#   /boot/acpi-override.img                        — cpio with the patched table
#   /boot/loader/entries/zz-cachyos-acpifix.conf   — a SEPARATE boot
#       entry "CachyOS (ACPI fix)". Regular entries are not touched, sdboot-manage
#       does not know about it and will not overwrite it.
#
# Check after booting through the new entry:
#   ./bootcheck.sh                     — GOOD expected (30+ W)
#   journalctl -k -b 0 | grep -i "ACPI: table upgrade\|NvdTable"
#
# Rollback: pick the regular entry in the boot menu, or delete both files.
set -euo pipefail
cd "$(dirname "$0")"

[ "$(id -u)" = 0 ] || { echo "root required: sudo $0"; exit 1; }
AML=acpi/nvdtable-patched.aml
[ -f "$AML" ] || { echo "no $AML, build it: cd acpi && iasl nvdtable-patched.dsl"; exit 1; }

# 1. cpio with the table at the path where the kernel looks for it
d=$(mktemp -d)
mkdir -p "$d/kernel/firmware/acpi"
cp "$AML" "$d/kernel/firmware/acpi/nvdtable-patched.aml"
(cd "$d" && find kernel -type f -o -type d | cpio -H newc -o --quiet) > /boot/acpi-override.img
rm -rf "$d"
echo "✔ /boot/acpi-override.img created ($(stat -c%s /boot/acpi-override.img) bytes)"

# 2. boot entry: a copy of the regular cachyos entry + our initrd line
#    BEFORE the other initrds (order matters: the kernel scans all of them, but we
#    put it first per the Arch Wiki)
src=$(grep -rl "vmlinuz-linux-cachyos" /boot/loader/entries/ 2>/dev/null | grep -v lts | grep -v acpifix | head -1)
[ -n "$src" ] || { echo "✖ regular cachyos entry not found in /boot/loader/entries/"; exit 1; }
dst=/boot/loader/entries/zz-cachyos-acpifix.conf
awk '
  /^title/   { print "title CachyOS (ACPI fix — NVPCF off)"; next }
  /^initrd/ && !done { print "initrd  /acpi-override.img"; done=1 }
  { print }
' "$src" > "$dst"
echo "✔ $dst created from $(basename "$src"):"
sed 's/^/    /' "$dst"
echo
echo "Next: reboot → pick \"CachyOS (ACPI fix)\" in the systemd-boot menu"
echo "→ ./bootcheck.sh. If all is well and you want it as the default entry:"
echo "  add this line to /boot/loader/loader.conf: default zz-cachyos-acpifix.conf"
