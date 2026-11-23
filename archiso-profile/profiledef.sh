#!/usr/bin/env bash
# shellcheck disable=SC2034
# Fenrir Linux - Unchained
# archiso profile definition

iso_name="fenrirlinux"
# The label is substituted into the boot menus (%ARCHISO_LABEL%) and read
# from the kernel command line by the initramfs, so it only lives here.
iso_label="FENRIR_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Fenrir Linux <https://fenrirlinux.org>"
iso_application="Fenrir Linux - Unchained Gaming Linux (installer)"
iso_version="0.1.0-alpha"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/usr/local/bin/fenrir-install"]="0:0:755"
  ["/usr/lib/initcpio/hooks/fenrir-udev"]="0:0:644"
  ["/usr/lib/initcpio/install/fenrir-udev"]="0:0:644"
)
