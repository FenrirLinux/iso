# FenrirOS - Unchained 🐺

> Gaming Linux, unchained from systemd.

FenrirOS is an Arch-based gaming Linux distribution built on OpenRC and elogind,
combining the performance of CachyOS kernels and SCX schedulers with a systemd-free
init system — making OpenRC approachable for everyday gamers.

---

## Project Structure

```
fenriros/
├── archiso-profile/          # Main archiso build profile
│   ├── profiledef.sh         # ISO metadata and build settings
│   ├── pacman.conf           # Package repos (CachyOS + Arch)
│   ├── packages.x86_64       # All packages included in ISO
│   └── airootfs/             # Filesystem overlay (maps to /)
│       ├── etc/
│       │   ├── init.d/       # OpenRC service files
│       │   ├── rc.conf       # OpenRC global config
│       │   └── pacman.d/     # Mirrorlist configs
│       └── usr/local/bin/
│           ├── fenrir-installer   # Install bootstrap script
│           └── fenrir-welcome     # First-boot welcome
└── docs/                     # Documentation
```

---

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
| Display Mgr | SDDM | Lightweight, KDE native |
| Gaming | Steam + Proton + Lutris | Full Linux gaming stack |

---

## Building the ISO

### Prerequisites (on CachyOS/Arch)

```bash
sudo pacman -S archiso
```

### Build

```bash
cd fenriros/
sudo mkarchiso -v -w /tmp/fenriros-work -o /tmp/fenriros-out archiso-profile/
```

The ISO will be output to `/tmp/fenriros-out/`.

---

## Key Technical Challenges

### elogind replacing systemd-logind
Steam and most DEs require `logind` for session/seat management.
`elogind` is a standalone fork that satisfies this without pulling in systemd.

### Pipewire without systemd socket activation
Pipewire normally relies on systemd user socket activation.
FenrirOS uses a custom OpenRC service + PAM environment approach instead.

### Gamemode
`gamemode` has some systemd assumptions in its DBus activation.
A patch is needed to use elogind's DBus session instead.

---

## Roadmap

- [ ] v0.1 — Bootable ISO with OpenRC + elogind + KDE
- [ ] v0.2 — Steam + full gaming stack validated
- [ ] v0.3 — Calamares installer with FenrirOS branding
- [ ] v0.4 — Custom FenrirOS repo with patched packages
- [ ] v1.0 — Stable release, DistroWatch listing

---

## Contributing

FenrirOS is in early development. Join the pack:
- GitHub: (coming soon)
- Discord: (coming soon)
- Website: fenriros.org (coming soon)

---

*"Unchained"* — like Fenrir himself, this distro breaks free.
