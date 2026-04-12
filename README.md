# FenrirOS - Unchained 🐺

> Gaming Linux, unchained from systemd.

FenrirOS is an Arch-based gaming Linux distribution built on OpenRC and elogind,
combining the performance of CachyOS kernels and SCX schedulers with a systemd-free
init system — making OpenRC approachable for everyday gamers.

## Project Structure

```
fenriros/
├── archiso-profile/          # Main archiso build profile
│   ├── profiledef.sh         # ISO metadata and build settings
│   ├── pacman.conf           # Package repos (CachyOS + Arch)
│   ├── packages.x86_64       # All packages included in ISO
│   └── airootfs/             # Filesystem overlay (maps to /)
├── packages/                 # Custom patched packages
│   └── gamemode-elogind/     # GameMode patched for OpenRC
├── configs/                  # System configuration files
│   └── pam/                  # PAM elogind session setup
└── docs/                     # Documentation
```

## Tech Stack

| Component | Choice | Reason |
|-----------|--------|--------|
| Base | Arch Linux | Rolling, flexible, large repo |
| Kernel | linux-cachyos | Performance patches, BORE/LAVD |
| Init | OpenRC | Lightweight, fast, systemd-free |
| Session | elogind | Standalone logind for DEs/Steam |
| Scheduler | SCX (LAVD) | Best gaming latency |
| Audio | Pipewire | Modern audio, works without systemd |
| DE | KDE Plasma | Wayland-ready, gamer-friendly |
| Gaming | Steam + Proton + Lutris | Full Linux gaming stack |

## Building the ISO

### Prerequisites (on CachyOS/Arch)

```bash
sudo pacman -S archiso
```

### Build

```bash
sudo mkarchiso -v -w /tmp/fenriros-work -o /tmp/fenriros-out archiso-profile/
```

## Links

- Website: https://fenrirlinux.org
- GitHub: https://github.com/FenrirLinux
- Discord: Coming soon
