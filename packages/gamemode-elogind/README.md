# gamemode-elogind

FenrirOS patched build of [GameMode](https://github.com/FeralInteractive/gamemode)
with elogind support for OpenRC systems.

## What's patched

GameMode upstream requires `libsystemd` for its internal D-Bus communication
via `sd-bus`. These patches replace that with `libelogind`, which provides a
compatible API without requiring systemd.

### Patch 1 — `0001-elogind-replace-systemd.patch`
Updates the meson build system to:
- Accept `elogind` as a valid `--with-sd-bus-provider` option
- Link against `libelogind` instead of `libsystemd`
- Add elogind include paths and `USE_ELOGIND` compile flag

### Patch 2 — `0002-elogind-dbus-session.patch`
Fixes D-Bus session bus detection:
- Under systemd, `sd_bus_default_user()` works via socket activation
- Under elogind/OpenRC, `DBUS_SESSION_BUS_ADDRESS` is set by PAM
- Adds fallback to `/run/user/<uid>/bus` if the env var is missing

## Building

```bash
# Install dependencies
sudo pacman -S meson ninja pkg-config libinih elogind

# Build
cd gamemode-elogind
makepkg -si
```

## OpenRC service

The `gamemoded.initd` file is the OpenRC init script for the GameMode daemon.
It's installed to `/etc/init.d/gamemoded` and handles elogind session
detection automatically.

Enable it:
```bash
sudo rc-update add gamemoded default
sudo rc-service gamemoded start
```

## PAM requirement

For the user session bus to be available, elogind's PAM module must be
active. Ensure `/etc/pam.d/system-login` contains:

```
session   optional   pam_elogind.so
```

This is handled automatically by the FenrirOS installer.

## Testing

After install, verify GameMode works:
```bash
# Check daemon is running
rc-service gamemoded status

# Test with a game
gamemoderun %command%

# Check active sessions
gamemoded -s
```
