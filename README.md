# FenrirLinux - Unchained 🐺

> Gaming Linux, unchained from systemd.

FenrirLinux (FenrirOS) is a gaming distribution built on **Artix Linux** (OpenRC +
elogind) with the **CachyOS** kernel and sched_ext schedulers. The goal is to make a
systemd-free system approachable for everyday gamers.

The ISO works like the Arch ISO: it boots to a console, you get online and run
**`fenrir-install`**, a guided installer that installs a fresh system from the repos.

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

## Installing

1. Boot the ISO (UEFI or BIOS, USB stick or Ventoy). You're logged in as root.
2. Get online: Ethernet connects by itself, for Wi-Fi run `nmtui`.
3. Optional: change the keyboard layout, e.g. `loadkeys de`.
4. Run `fenrir-install` and answer the questions:
   - **disk**: pick a disk to erase, or partition it yourself, mount it at `/mnt`
     (EFI partition at `/mnt/boot/efi`) and pick "manual"
   - **filesystem**: btrfs (subvolumes `@`, `@home`, `@swap`, zstd compression) or ext4
   - **swap file** size
   - **profile**: `desktop` (KDE Plasma + gaming) or `minimal` (console only)
   - hostname, user and password, time zone, locale, keyboard layout
5. Type `ERASE` to confirm, wait for the download, then reboot.

NVIDIA GPUs are detected and get CachyOS's prebuilt driver automatically. Root
login is disabled; your user is an admin through `sudo`.

For repeat installs (VMs, testing), put the answers in a file and run
`fenrir-install -c answers.conf`. See `fenrir-install -h` for the variables.
Passwords are always asked for. The full log ends up in
`/var/log/fenrir-install.log` on the new system.

## Repository layout

```
archiso-profile/                 the live ISO (console only)
├── profiledef.sh                ISO metadata, boot modes, file permissions
├── pacman.conf                  repos used to build the ISO
├── packages.x86_64              packages on the live ISO
├── grub/ syslinux/              boot menus (+ loopback.cfg for Ventoy/GRUB ISO boot)
└── airootfs/                    files on the live ISO
    ├── usr/local/bin/fenrir-install     the installer
    └── usr/share/fenrir/
        ├── packages/base.txt            installed on every system
        ├── packages/desktop.txt         added for the desktop profile
        └── rootfs/                      copied onto every installed system:
            ├── usr/local/bin/           driver manager, kernel switcher,
            │                            NVIDIA setup, PipeWire launcher
            ├── etc/init.d/scx           sched_ext service
            └── usr/lib/firefox/         Fenrir Browser policies and defaults
assets/                          artwork and the Fenrir Browser theme source
build.sh                         build script
index.html                       fenrirlinux.org landing page
```

To change what gets installed, edit the package lists or drop files into
`rootfs/`. No installer code changes needed.

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

## Roadmap

- [x] v0.1: Bootable ISO with OpenRC + elogind + KDE
- [ ] v0.2: Steam + full gaming stack validated
- [ ] v0.3: `fenrir-install` validated on UEFI and BIOS hardware
- [ ] v0.4: Custom FenrirOS repo (ship `rootfs/` as a `fenrir-base` package)
- [ ] v1.0: Stable release, DistroWatch listing

## Links

- Website: https://fenrirlinux.org
- Issues: https://github.com/FenrirLinux/iso/issues

---

*"Unchained": like Fenrir himself, this distro breaks free.*
