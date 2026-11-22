#!/usr/bin/env bash
# ==============================================================================
# Build the Fenrir Linux ISO inside an Arch Linux container.
# For hosts that aren't Arch-based (NixOS, Fedora, Ubuntu, ...).
#
#   sudo ./scripts/build-in-container.sh          # ISO ends up in ./out/
#   sudo ./scripts/build-in-container.sh --clean  # extra args go to build.sh
#
# Needs podman or docker. The container has to be privileged and rootful
# (run with sudo) because mkarchiso mounts proc/sys/dev while it installs
# packages into the image.
#
# NixOS: add one of these to configuration.nix and rebuild:
#   virtualisation.podman.enable = true;
#   virtualisation.docker.enable = true;
# ==============================================================================

set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
IMAGE=${IMAGE:-docker.io/archlinux/archlinux:latest}

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo: the container must be privileged and rootful." >&2
    exit 1
fi

if command -v podman >/dev/null; then
    engine=podman
elif command -v docker >/dev/null; then
    engine=docker
else
    echo "Neither podman nor docker was found." >&2
    echo "On NixOS add 'virtualisation.podman.enable = true;' to configuration.nix." >&2
    exit 1
fi

echo "==> Building in ${IMAGE} with ${engine} (this takes a while)"
# shellcheck disable=SC2016 # expanded inside the container
"$engine" run --rm --privileged \
    -e OWNER="${SUDO_UID:-0}:${SUDO_GID:-0}" \
    -v "${REPO_DIR}:/build" -w /build \
    "$IMAGE" \
    bash -euo pipefail -c '
        pacman-key --init >/dev/null 2>&1
        pacman-key --populate archlinux >/dev/null 2>&1
        echo "==> Installing archiso in the container"
        pacman -Syu --noconfirm --needed archiso grub >/dev/null
        ./build.sh "$@"
        # Give the ISO back to the user who ran sudo.
        chown -R "$OWNER" out
    ' build-in-container "$@"

echo "==> ISO:"
ls -lh "$REPO_DIR"/out/*.iso
