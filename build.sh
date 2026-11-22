#!/usr/bin/env bash
# ==============================================================================
# Fenrir Linux ISO build script
#
#   sudo ./build.sh            # ISO ends up in ./out/
#   sudo WORK_DIR=/tmp/fw OUT_DIR=/tmp/fo ./build.sh
#   sudo ./build.sh --clean    # throw away the previous build first
#
# Works on Arch, CachyOS or Artix with archiso installed. The build host's own
# pacman keyring is never touched: signatures are checked against a separate
# keyring in $WORK_DIR/gnupg that holds the Arch, Artix, CachyOS and Fenrir keys.
# ==============================================================================

set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WORK_DIR=${WORK_DIR:-$REPO_DIR/work}
OUT_DIR=${OUT_DIR:-$REPO_DIR/out}
PROFILE_SRC=$REPO_DIR/archiso-profile
PROFILE=$WORK_DIR/profile
GNUPG=$WORK_DIR/gnupg

# shellcheck disable=SC2016 # pacman expands $repo/$arch, not bash
ARTIX_MIRROR='https://mirrors.dotsrc.org/artix-linux/repos/$repo/os/$arch'
# shellcheck disable=SC2016
CACHYOS_MIRROR='https://mirror.cachyos.org/repo/$arch/$repo'
FENRIR_MIRROR='https://github.com/FenrirLinux/packages/releases/download/repo'

msg()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==> WARNING:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m==> ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "run as root: sudo $0"
for cmd in mkarchiso pacman pacman-key gpg bsdtar; do
    command -v "$cmd" >/dev/null || die "$cmd not found (sudo pacman -S archiso)"
done
# mkarchiso builds the UEFI boot image with the host's GRUB.
command -v grub-mkstandalone >/dev/null || die "grub not found (sudo pacman -S grub)"

if [[ ${1:-} == --clean ]]; then
    msg "Removing previous build in $WORK_DIR"
    rm -rf "$WORK_DIR"
fi
mkdir -p "$WORK_DIR" "$OUT_DIR"

# ------------------------------------------------------------------------------
# Keyring
# ------------------------------------------------------------------------------
# Download a keyring package from a repo without trusting anything yet.
# The download itself is only protected by HTTPS - this is the bootstrap step.
fetch_keyring_pkg() {
    local pkg=$1 repo=$2 server=$3 tmp=$WORK_DIR/keyring-fetch
    mkdir -p "$tmp/db" "$tmp/pkgs"
    cat > "$tmp/pacman.conf" <<EOF
[options]
Architecture = x86_64
SigLevel = Never
[$repo]
Server = $server
EOF
    pacman --config "$tmp/pacman.conf" --dbpath "$tmp/db" -Sy >/dev/null
    pacman --config "$tmp/pacman.conf" --dbpath "$tmp/db" --cachedir "$tmp/pkgs" \
        -Sw --nodeps --nodeps --noconfirm "$pkg" >/dev/null
    find "$tmp/pkgs" -name "${pkg}-[0-9]*.pkg.tar.*" ! -name '*.sig' | sort -V | tail -n1
}

setup_keyring() {
    if [[ -f $GNUPG/.fenrir-ready-v4 ]]; then
        msg "Reusing build keyring in $GNUPG (use --clean to refresh it)"
        return
    fi
    msg "Creating build keyring in $GNUPG"
    rm -rf "$GNUPG"
    pacman-key --gpgdir "$GNUPG" --init >/dev/null 2>&1

    local keyrings=$WORK_DIR/keyrings pkg
    rm -rf "$keyrings"; mkdir -p "$keyrings"

    # Arch keys from the host (every Arch-based host has them).
    cp /usr/share/pacman/keyrings/archlinux* "$keyrings/" \
        || die "host has no archlinux keyring (sudo pacman -S archlinux-keyring)"

    for spec in "artix-keyring system $ARTIX_MIRROR" "cachyos-keyring cachyos $CACHYOS_MIRROR" \
                "fenrir-keyring fenrir $FENRIR_MIRROR"; do
        read -r name repo server <<< "$spec"
        msg "Fetching $name"
        pkg=$(fetch_keyring_pkg "$name" "$repo" "$server")
        [[ -n $pkg ]] || die "could not download $name"
        bsdtar -xf "$pkg" -C "$keyrings" --strip-components 4 usr/share/pacman/keyrings
    done

    # Run the real "pacman-key --populate" (import, locally sign, owner
    # trust, disable revoked keys). It only reads keyrings from
    # /usr/share/pacman/keyrings, so show it our folder there through a
    # bind mount in a private mount namespace; the host is not changed.
    unshare --mount --propagation private sh -c '
        mount --bind "$1" /usr/share/pacman/keyrings &&
        pacman-key --gpgdir "$2" --populate archlinux artix cachyos fenrir
    ' populate "$keyrings" "$GNUPG" >/dev/null || die "could not populate the build keyring"
    gpgconf --homedir "$GNUPG" --kill all >/dev/null 2>&1 || true
    touch "$GNUPG/.fenrir-ready-v4"
}

# ------------------------------------------------------------------------------
# Profile
# ------------------------------------------------------------------------------
prepare_profile() {
    msg "Preparing profile in $PROFILE"
    rm -rf "$PROFILE"
    cp -a "$PROFILE_SRC" "$PROFILE"

    # Use the build keyring for signature checks, and a package cache of our
    # own: the host's cache holds Arch builds with the same file names as
    # Artix packages (glibc, zlib, ...), which would fail Artix's signatures.
    mkdir -p "$WORK_DIR/pkgcache"
    sed -i "/^\[options\]/a GPGDir = $GNUPG\nCacheDir = $WORK_DIR/pkgcache/" "$PROFILE/pacman.conf"
}

setup_keyring
prepare_profile

msg "Building ISO"
rm -rf "$WORK_DIR/mkarchiso"
mkarchiso -v -w "$WORK_DIR/mkarchiso" -o "$OUT_DIR" "$PROFILE"

msg "Done:"
ls -lh "$OUT_DIR"/*.iso
