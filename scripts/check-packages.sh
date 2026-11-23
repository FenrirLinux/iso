#!/usr/bin/env bash
# ==============================================================================
# Check that fenrir-install's package lists resolve against the real repos,
# without installing anything. Catches typos, renamed packages and virtual
# dependencies that would pick the wrong provider (e.g. dinit instead of
# OpenRC) before someone hits them halfway through an install.
#
#   sudo ./scripts/check-packages.sh [pacman.conf]
#
# Uses the build profile's pacman.conf (and keyring) by default, so run
# build.sh once first, or pass a pacman.conf.
# ==============================================================================

set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CONF=${1:-$REPO_DIR/work/profile/pacman.conf}
LISTS=$REPO_DIR/archiso-profile/airootfs/usr/share/fenrir/packages
DB=$(mktemp -d)
trap 'rm -rf "$DB"' EXIT

[[ -f $CONF ]] || { echo "pacman.conf not found: $CONF (run build.sh first)" >&2; exit 1; }

read_list() { sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$1"; }

pacman --config "$CONF" --dbpath "$DB" -Sy >/dev/null

status=0
for profile in base "base desktop"; do
    pkgs=()
    for list in $profile; do
        mapfile -t -O "${#pkgs[@]}" pkgs < <(read_list "$LISTS/$list.txt")
    done
    echo "==> Resolving profile: ${profile// / + } (${#pkgs[@]} packages)"
    out=$(pacman --config "$CONF" --dbpath "$DB" -Sp --noconfirm --print-format '%n %r' "${pkgs[@]}" 2>&1) || {
        echo "$out" | grep -vE '^[a-z0-9@._+-]+ [a-z0-9]+$' >&2
        status=1
        continue
    }
    # The init system must stay OpenRC: no dinit/runit/s6 or systemd packages.
    bad=$(echo "$out" | awk '{print $1}' | grep -E -- '-(dinit|runit|s6)$|^(dinit|runit|s6|systemd|systemd-sysvcompat)$' || true)
    if [[ -n $bad ]]; then
        echo "ERROR: would pull in packages for the wrong init system:" >&2
        echo "$bad" | sed 's/^/    /' >&2
        status=1
    fi
    echo "$out" | awk '{print $2}' | sort | uniq -c | sed 's/^/    /'
done
# Optionally do a real install of everything into a scratch root, like
# fenrir-install's basestrap does. Catches file conflicts, broken install
# scripts and signature problems that resolving alone can't see.
if [[ ${TRIAL_INSTALL:-0} == 1 && $status -eq 0 ]]; then
    root=$(mktemp -d /tmp/fenrir-trial.XXXX)
    pkgs=()
    for list in base desktop; do
        mapfile -t -O "${#pkgs[@]}" pkgs < <(read_list "$LISTS/$list.txt")
    done
    echo "==> Trial install of ${#pkgs[@]} packages into $root"
    if pacstrap -C "$CONF" -G -M "$root" "${pkgs[@]}" > /tmp/trial-install.log 2>&1; then
        echo "    trial install OK"
        grep -q '^\[fenrir\]' "$root/etc/pacman.conf" \
            || { echo "ERROR: fenrir-base did not add [fenrir] to pacman.conf" >&2; status=1; }
    else
        echo "ERROR: trial install failed:" >&2
        grep -n -i -E 'error|conflict|exists in filesystem|invalid|corrupted|unknown trust|not found' \
            /tmp/trial-install.log | head -40 >&2
        status=1
    fi
fi
exit "$status"
