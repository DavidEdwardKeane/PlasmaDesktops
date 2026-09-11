#!/usr/bin/env bash

log() {
    printf '[INFO] %s\n' "$*" >&2
}

ok() {
    printf '[ OK ] %s\n' "$*" >&2
}

warn() {
    printf '[WARN] %s\n' "$*" >&2
}

die() {
    printf '[ERROR] %s\n' "$*" >&2
    exit 1
}

have_command() {
    command -v "$1" >/dev/null 2>&1
}
