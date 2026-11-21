# FenrirLinux - Unchained 🐺

> Gaming Linux, unchained from systemd.

FenrirLinux (FenrirOS) is a gaming distribution built on **Artix Linux** (OpenRC +
elogind) with the **CachyOS** kernel and sched_ext schedulers. The goal is to make a
systemd-free system approachable for everyday gamers.

---

## Tech stack

| Component   | Choice                         | Notes |
|-------------|--------------------------------|-------|
| Base        | Artix Linux                    | `system`, `world`, `galaxy`, `lib32` repos; Arch `extra`/`multilib` as fallback |
| Kernel      | linux-cachyos                  | From the `cachyos` repo, prebuilt NVIDIA modules available |
| Init        | OpenRC                         | |
| Session     | elogind                        | logind for SDDM, KDE, Steam and gamemode |
| Scheduler   | scx_lavd (sched_ext)           | `/etc/init.d/scx`, configured in `/etc/conf.d/scx` |
| Audio       | PipeWire + WirePlumber         | Started per session by `fenrir-pipewire-launcher` |
| Desktop     | KDE Plasma 6 (Wayland)         | SDDM |
| Gaming      | Steam, Lutris, Wine, gamemode, MangoHud | |
| Installer   | Calamares + `fenrir-postinstall` | UEFI and BIOS |

## Repository layout

```
archiso-profile/              archiso profile (this is what gets built)
├── profiledef.sh             ISO metadata, boot modes, file permissions
├── pacman.conf               repos used to build the ISO
├── packages.x86_64           packages on the ISO (and installed systems)
├── grub/                     UEFI boot menu + loopback.cfg (Ventoy/GRUB ISO boot)
├── syslinux/                 BIOS boot menu
└── airootfs/                 files copied over the root filesystem
    ├── etc/calamares/        installer settings and branding config
    ├── etc/mkinitcpio.*      live-ISO-only initramfs preset
    ├── etc/init.d/scx        OpenRC service for sched_ext schedulers
    └── usr/local/bin/
        ├── fenrir-postinstall       turns the copied live system into an install
        ├── fenrir-nvidia-setup      NVIDIA driver install (CachyOS prebuilt modules)
        ├── fenrir-driver-manager    GPU driver GUI
        ├── fenrir-kernel-switcher   CachyOS kernel GUI
        ├── fenrir-pipewire-launcher starts PipeWire for the session
        └── fenrir-os-release        re-applies branding (run by a pacman hook)
assets/                       artwork and the Fenrir Browser theme source
build.sh                      build script
index.html                    fenrirlinux.org landing page
```

## Building the ISO

On Arch, CachyOS or Artix:

```bash
sudo pacman -S archiso
sudo ./build.sh            # ISO is written to ./out/
sudo ./build.sh --clean    # start from scratch
```

`build.sh` keeps its own pacman keyring in `work/gnupg` with the Arch, Artix and
CachyOS keys, so packages are signature-checked without changing your host's
keyring. You can also run a full build in GitHub Actions: **Actions → Check → Run
workflow**.

## How installing works

Calamares copies the live system to disk, then runs
`/usr/local/bin/fenrir-postinstall` inside it. That script:

1. removes live-only config (passwordless sudo, autologin, archiso initramfs, Calamares)
2. creates a new machine-id and pacman keyring, locks root (use `sudo`)
3. installs each kernel to `/boot` with a normal mkinitcpio preset, so kernel
   updates keep working
4. installs NVIDIA drivers if an NVIDIA GPU is found (needs internet)
5. enables the OpenRC services and gaming sysctl tweaks
6. installs GRUB for UEFI (plus the fallback `EFI/BOOT/BOOTX64.EFI`) or BIOS

Then Calamares creates your user. The full installer log is saved to
`/var/log/installation.log` on the new system.

## Roadmap

- [x] v0.1: Bootable ISO with OpenRC + elogind + KDE
- [ ] v0.2: Steam + full gaming stack validated
- [ ] v0.3: Calamares installer validated on UEFI and BIOS hardware
- [ ] v0.4: Custom FenrirOS repo for our own packages
- [ ] v1.0: Stable release, DistroWatch listing

## Links

- Website: https://fenrirlinux.org
- Issues: https://github.com/FenrirLinux/iso/issues

---

*"Unchained": like Fenrir himself, this distro breaks free.*
