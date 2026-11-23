# Installing Fenrir Linux by hand

`fenrir-install` does all of this for you. This guide is for doing it yourself,
the Arch way. The live ISO already has everything needed: `basestrap`,
`fstabgen`, `artix-chroot`, `cfdisk`/`gdisk`, the `mkfs` tools, and `nmtui`.

Fenrir is Artix (OpenRC + elogind) plus the `[fenrir]` repository. Installing
the `fenrir-base` package is what makes it Fenrir: branding, the repos in
`pacman.conf`, the scx service and gaming tweaks. `fenrir-desktop` adds the
desktop bits. There's nothing to copy by hand.

## 1. Get online

Ethernet connects by itself. For Wi-Fi run `nmtui`. Check with
`ping -c 3 artixlinux.org`.

## 2. Partition, format and mount

Examples for one disk, `/dev/nvme0n1` (use `lsblk` to find yours).

**UEFI** (check: `ls /sys/firmware/efi` exists):

```bash
cfdisk /dev/nvme0n1          # GPT: 1G "EFI System" + the rest "Linux filesystem"
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2     # or mkfs.btrfs, see below
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
```

**BIOS:** with GPT, make a 1M partition of type "BIOS boot" first, then the root
partition. With an MBR (dos) table, one root partition is enough.

**btrfs with subvolumes** (what `fenrir-install` does):

```bash
mkfs.btrfs /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
mount -o subvol=@,noatime,compress=zstd:1 /dev/nvme0n1p2 /mnt
mkdir -p /mnt/home
mount -o subvol=@home,noatime,compress=zstd:1 /dev/nvme0n1p2 /mnt/home
```

## 3. Install packages

The package lists `fenrir-install` uses are on the ISO:

```bash
basestrap /mnt $(sed 's/#.*//' /usr/share/fenrir/packages/base.txt)
# KDE Plasma + gaming (leave out for a console-only system):
basestrap /mnt $(sed 's/#.*//' /usr/share/fenrir/packages/desktop.txt)

fstabgen -U /mnt >> /mnt/etc/fstab
```

Or choose your own. The minimum is
`base openrc elogind-openrc linux-cachyos linux-firmware mkinitcpio grub fenrir-base`.

## 4. Configure the new system

```bash
artix-chroot /mnt

# Time zone and clock
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

# Language: uncomment your locale(s), e.g. en_US.UTF-8 UTF-8
nano /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=us > /etc/vconsole.conf

# Hostname (OpenRC reads /etc/conf.d/hostname)
echo fenrir > /etc/hostname
echo 'hostname="fenrir"' > /etc/conf.d/hostname

# Package keyring for the new system
pacman-key --init
pacman-key --populate artix archlinux cachyos fenrir

# Your user (admin through sudo) and password
useradd -m -G wheel,audio,video,input,storage,optical,network -s /bin/bash yourname
passwd yourname
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/10-wheel
passwd -l root            # optional: disable root login

# Services
rc-update add udev sysinit
for s in dbus elogind NetworkManager chronyd cronie acpid scx; do rc-update add $s default; done
rc-update add bluetoothd default   # desktop
rc-update add sddm default         # desktop: graphical login

# NVIDIA GPU? Installs CachyOS's prebuilt driver for your kernel(s):
fenrir-nvidia-setup --no-rebuild
```

## 5. Boot loader

```bash
mkinitcpio -P
```

UEFI:

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=FenrirLinux
grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable   # fallback path
```

BIOS (the disk, not a partition):

```bash
grub-install --target=i386-pc /dev/sda
```

Then:

```bash
echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub   # find Windows etc.
grub-mkconfig -o /boot/grub/grub.cfg
```

## 6. Reboot

```bash
exit
umount -R /mnt
reboot
```

## Turning an existing Artix install into Fenrir

Add the key and the repo, then install `fenrir-base`; it sets up the rest:

```bash
sudo pacman-key --add fenrir.gpg      # from github.com/FenrirLinux/packages
sudo pacman-key --lsign-key 4581C968246C120EA57FA4E3B7933835D7CF661A
# add above [system] in /etc/pacman.conf:
#   [fenrir]
#   Server = https://github.com/FenrirLinux/packages/releases/download/repo
sudo pacman -Syu fenrir-base
```
