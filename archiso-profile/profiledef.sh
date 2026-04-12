#!/usr/bin/env bash
# FenrirOS - Unchained
# archiso profile definition

iso_name="fenriros"
iso_label="FENRIR_202604"
iso_publisher="FenrirOS <https://fenriros.org>"
iso_application="FenrirOS - Unchained Gaming Linux"
iso_version="0.1.0-alpha"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')

# Allow elogind/openrc files to overwrite systemd-owned paths
pacman_options=('--overwrite' '/usr/share/man/man3/sd_*'
                '--overwrite' '/usr/share/man/man3/SD_*'
                '--overwrite' '/usr/lib/libudev*'
                '--overwrite' '/usr/include/libudev*'
                '--overwrite' '/usr/lib/pkgconfig/libudev*'
                '--overwrite' '/usr/share/libalpm/hooks/dbus-reload.hook'
                '--overwrite' '/usr/bin/busctl'
                '--overwrite' '/usr/bin/loginctl'
                '--overwrite' '/usr/lib/udev/rules.d/70-power-switch.rules'
                '--overwrite' '/usr/lib/udev/rules.d/70-uaccess.rules'
                '--overwrite' '/usr/lib/udev/rules.d/71-seat.rules'
                '--overwrite' '/usr/lib/udev/rules.d/73-seat-late.rules'
                '--overwrite' '/usr/share/bash-completion/completions/busctl'
                '--overwrite' '/usr/share/bash-completion/completions/loginctl'
                '--overwrite' '/usr/share/dbus-1/system-services/org.freedesktop.login1.service'
                '--overwrite' '/usr/share/dbus-1/system.d/org.freedesktop.login1.conf'
                '--overwrite' '/usr/share/man/man1/busctl*'
                '--overwrite' '/usr/share/man/man1/loginctl*'
                '--overwrite' '/usr/share/man/man5/logind*'
                '--overwrite' '/usr/share/man/man5/org.freedesktop.login1*'
                '--overwrite' '/usr/share/man/man5/sleep.conf*'
                '--overwrite' '/usr/share/polkit-1/actions/org.freedesktop.login1.policy'
                '--overwrite' '/usr/share/zsh/site-functions/_busctl'
                '--overwrite' '/usr/share/zsh/site-functions/_loginctl'
                '--overwrite' '/usr/lib/sysctl.d/50-default.conf'
                '--overwrite' '/usr/lib/sysusers.d/*'
                '--overwrite' '/usr/share/man/man5/sysusers.d*'
                '--overwrite' '/usr/lib/tmpfiles.d/*'
                '--overwrite' '/usr/share/factory/etc/*'
                '--overwrite' '/usr/share/man/man5/tmpfiles*')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/usr/local/bin/fenrir-installer"]="0:0:755"
  ["/usr/local/bin/fenrir-setup-pam"]="0:0:755"
  ["/usr/local/bin/fenrir-pacman"]="0:0:755"
)
