#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

install -Dm755 "$ROOT_DIR/bin/plasma-installer" \
    "$HOME/.local/bin/plasma-installer"

install -Dm644 "$ROOT_DIR/profiles/workstation.conf" \
    "$HOME/.local/share/plasma-installer/profiles/workstation.conf"

echo "Installed plasma-installer to ~/.local/bin/plasma-installer"
