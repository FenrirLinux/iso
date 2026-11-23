# Tools to test Fenrir Linux ISOs on NixOS (or anywhere with Nix):
#   nix-shell --run ./scripts/test-vm.sh
#
# Building the ISO needs an Arch container instead (podman or docker,
# enabled in configuration.nix): sudo ./scripts/build-in-container.sh
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = [ pkgs.qemu_kvm pkgs.shellcheck ];

  # UEFI firmware for QEMU, picked up by scripts/test-vm.sh
  OVMF_CODE = "${pkgs.OVMF.fd}/FV/OVMF_CODE.fd";
  OVMF_VARS = "${pkgs.OVMF.fd}/FV/OVMF_VARS.fd";
}
