#!/usr/bin/env bash
# FenrirOS - customize_airootfs.sh
# Runs inside the airootfs during build to set up live environment

set -e

# Set root password to empty (no password for live ISO)
passwd -d root

# Create live user
useradd -m -G wheel,audio,video,storage,optical,input -s /bin/bash fenrir
passwd -d fenrir

# Allow wheel group to use sudo without password
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

# Enable OpenRC services for live boot
rc-update add udev sysinit
rc-update add dbus default
rc-update add elogind default
rc-update add NetworkManager default
rc-update add sddm default

echo "FenrirOS live environment configured"
