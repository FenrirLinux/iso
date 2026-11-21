#!/usr/bin/env bash
# shellcheck disable=SC2034
# FenrirOS - Unchained
# archiso profile definition

iso_name="fenriros"
# The label is substituted into the boot menus (%ARCHISO_LABEL%) and read
# from the kernel command line by the initramfs, so it only lives here.
iso_label="FENRIR_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="FenrirOS <https://fenrirlinux.org>"
iso_application="FenrirOS - Unchained Gaming Linux"
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
  ["/etc/sudoers.d/live"]="0:0:440"
  ["/etc/init.d/scx"]="0:0:755"
  ["/etc/local.d/pacman-init.start"]="0:0:755"
  ["/usr/local/bin/fenrir-postinstall"]="0:0:755"
  ["/usr/local/bin/fenrir-os-release"]="0:0:755"
  ["/usr/local/bin/fenrir-kernel-switcher"]="0:0:755"
  ["/usr/local/bin/fenrir-driver-manager"]="0:0:755"
  ["/usr/local/bin/fenrir-nvidia-setup"]="0:0:755"
  ["/usr/local/bin/fenrir-pipewire-launcher"]="0:0:755"
  ["/usr/lib/initcpio/hooks/fenrir-udev"]="0:0:644"
  ["/usr/lib/initcpio/install/fenrir-udev"]="0:0:644"
  ["/home/fenrir"]="1000:1000:750"
  ["/home/fenrir/Desktop/install-fenriros.desktop"]="1000:1000:755"
)
