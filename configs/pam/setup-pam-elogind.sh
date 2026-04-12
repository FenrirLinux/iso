#!/usr/bin/env bash
# FenrirOS - PAM elogind setup
# Called by fenrir-installer during post-install
# Configures PAM for proper elogind session management

set -euo pipefail

TARGET="${1:-/mnt}"

log() { echo "[PAM] $1"; }

configure_pam() {
    log "Installing FenrirOS PAM configuration..."

    # Install PAM configs
    install -Dm644 /etc/fenrir/pam/system-login \
        "$TARGET/etc/pam.d/system-login"

    install -Dm644 /etc/fenrir/pam/sddm \
        "$TARGET/etc/pam.d/sddm"

    install -Dm644 /etc/fenrir/pam/environment \
        "$TARGET/etc/environment"

    log "PAM configs installed"
}

verify_pam_elogind() {
    log "Verifying pam_elogind.so is available..."

    # Check elogind PAM module exists
    if ! arch-chroot "$TARGET" \
        find /usr/lib/security /lib/security \
        -name "pam_elogind.so" 2>/dev/null | grep -q .; then
        log "WARNING: pam_elogind.so not found - elogind may not be installed"
        log "Installing elogind..."
        arch-chroot "$TARGET" pacman -S --noconfirm elogind
    else
        log "pam_elogind.so found - OK"
    fi
}

configure_xdg_runtime() {
    log "Configuring XDG_RUNTIME_DIR setup..."

    # elogind creates /run/user/<uid> automatically on login
    # but we need tmpfiles.d to ensure /run/user exists
    cat > "$TARGET/etc/tmpfiles.d/fenrir-runtime.conf" << 'EOF'
# FenrirOS - ensure /run/user exists for elogind sessions
d /run/user 0755 root root -
EOF

    log "XDG runtime dir configured"
}

configure_pam
verify_pam_elogind
configure_xdg_runtime

log "PAM elogind configuration complete"
log "Users logging in via SDDM will have:"
log "  - XDG_RUNTIME_DIR=/run/user/<uid>"
log "  - DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/<uid>/bus"
log "  - Proper seat assignment for GPU/input access"
