#!/usr/bin/env bash

backup_config() {
    local timestamp backup_dir

    timestamp="$(date '+%Y%m%d-%H%M%S')"
    backup_dir="$HOME/.local/state/plasma-installer/backups/$timestamp"

    mkdir -p "$backup_dir"

    log "Creating configuration backup: $backup_dir"

    # Keep this deliberately conservative for now.
    # Add individual KDE/Plasma config files here as they become supported.

    if [[ -d "$HOME/.config" ]]; then
        cp -a "$HOME/.config" "$backup_dir/config"
    fi

    ok "Backup created: $backup_dir"
}
