#!/usr/bin/env bash
# ==============================================================================
# Boot a Fenrir Linux ISO (or the system installed from it) in QEMU.
#
#   ./scripts/test-vm.sh                    # newest ISO in ./out, UEFI
#   ./scripts/test-vm.sh --bios             # legacy BIOS instead of UEFI
#   ./scripts/test-vm.sh --installed        # boot the virtual disk, no ISO
#   ./scripts/test-vm.sh --reset            # start over with an empty disk
#   ./scripts/test-vm.sh path/to/file.iso
#
# State lives in ./vm/: a 40 GB disk image and the UEFI variables, kept
# separately for UEFI and BIOS so you can test both.
#
# On NixOS, run it from the repo's nix shell, which provides QEMU and the
# UEFI firmware:   nix-shell --run ./scripts/test-vm.sh
#
# Inside the VM the disk is /dev/vda. For a hands-off test install run:
#   fenrir-install -c /usr/share/fenrir/examples/vm-test.conf
# (it asks only for the password). SSH into the VM: ssh -p 2222 user@localhost
# ==============================================================================

set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VM_DIR=$REPO_DIR/vm
MODE=uefi
USE_ISO=1
RESET=0
ISO=""
RAM=${RAM:-8G}
CPUS=${CPUS:-4}

for arg in "$@"; do
    case "$arg" in
        --bios)      MODE=bios ;;
        --uefi)      MODE=uefi ;;
        --installed) USE_ISO=0 ;;
        --reset)     RESET=1 ;;
        -h|--help)   sed -n '3,23p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)          echo "unknown option: $arg" >&2; exit 1 ;;
        *)           ISO=$arg ;;
    esac
done

command -v qemu-system-x86_64 >/dev/null || {
    echo "qemu-system-x86_64 not found. On NixOS: nix-shell --run ./scripts/test-vm.sh" >&2
    exit 1
}

mkdir -p "$VM_DIR"
DISK=$VM_DIR/disk-${MODE}.qcow2
VARS=$VM_DIR/OVMF_VARS-${MODE}.fd
((RESET)) && rm -f "$DISK" "$VARS"
[[ -f $DISK ]] || qemu-img create -q -f qcow2 "$DISK" 40G

# shellcheck disable=SC2054 # commas are QEMU option syntax
args=(
    -name "Fenrir Linux test (${MODE^^})"
    -machine q35 -m "$RAM" -smp "$CPUS"
    -drive "file=${DISK},if=virtio,format=qcow2"
    -device virtio-vga -display gtk
    -nic "user,model=virtio-net-pci,hostfwd=tcp::2222-:22"
    -device intel-hda -device hda-duplex,audiodev=snd
    -audiodev "${AUDIO:-pa},id=snd"
    -device qemu-xhci -device usb-tablet
)

if [[ -w /dev/kvm ]]; then
    args+=(-enable-kvm -cpu host)
else
    echo "WARNING: /dev/kvm isn't usable, the VM will be very slow." >&2
fi

if [[ $MODE == uefi ]]; then
    find_fw() {
        local var=$1; shift
        if [[ -n ${!var:-} ]]; then echo "${!var}"; return; fi
        local f
        for f in "$@"; do [[ -f $f ]] && { echo "$f"; return; }; done
    }
    code=$(find_fw OVMF_CODE \
        /run/libvirt/nix-ovmf/OVMF_CODE.fd \
        /usr/share/edk2/x64/OVMF_CODE.4m.fd \
        /usr/share/OVMF/OVMF_CODE_4M.fd /usr/share/OVMF/OVMF_CODE.fd \
        /usr/share/edk2/ovmf/OVMF_CODE.fd)
    vars=$(find_fw OVMF_VARS \
        /run/libvirt/nix-ovmf/OVMF_VARS.fd \
        /usr/share/edk2/x64/OVMF_VARS.4m.fd \
        /usr/share/OVMF/OVMF_VARS_4M.fd /usr/share/OVMF/OVMF_VARS.fd \
        /usr/share/edk2/ovmf/OVMF_VARS.fd)
    if [[ -z $code || -z $vars ]]; then
        echo "UEFI firmware (OVMF) not found. On NixOS: nix-shell --run ./scripts/test-vm.sh" >&2
        echo "or set OVMF_CODE and OVMF_VARS, or use --bios." >&2
        exit 1
    fi
    [[ -f $VARS ]] || install -m644 "$vars" "$VARS"
    args+=(
        -drive "if=pflash,format=raw,readonly=on,file=${code}"
        -drive "if=pflash,format=raw,file=${VARS}"
    )
fi

if ((USE_ISO)); then
    if [[ -z $ISO ]]; then
        ISO=$(find "$REPO_DIR/out" -maxdepth 1 -name '*.iso' -printf '%T@ %p\n' 2>/dev/null \
            | sort -n | tail -n1 | cut -d' ' -f2-)
    fi
    [[ -n $ISO && -f $ISO ]] || { echo "No ISO found. Build one first, or pass its path." >&2; exit 1; }
    echo "==> Booting $(basename "$ISO") (${MODE^^})"
    args+=(-cdrom "$ISO" -boot once=d)
else
    echo "==> Booting the installed system (${MODE^^})"
fi

exec qemu-system-x86_64 "${args[@]}"
