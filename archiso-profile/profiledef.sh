#!/usr/bin/env bash
# FenrirOS - Unchained
# archiso profile definition

iso_name="fenriros"
iso_label="FENRIR_$(date +%Y%m)"
iso_publisher="FenrirOS <https://fenriros.org>"
iso_application="FenrirOS - Unchained Gaming Linux"
iso_version="0.1.0-alpha"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/usr/local/bin/fenrir-installer"]="0:0:755"
  ["/usr/local/bin/fenrir-welcome"]="0:0:755"
  ["/usr/local/bin/fenrir-setup-pam"]="0:0:755"
)
