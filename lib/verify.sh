#!/usr/bin/env bash

verify_installation() {
    local failed=0

    printf '%s\n' "Plasma Installer Verification"
    printf '%s\n' "=============================="

    if [[ -n "${XDG_CURRENT_DESKTOP:-}" ]]; then
        ok "Desktop: $XDG_CURRENT_DESKTOP"
    else
        warn "XDG_CURRENT_DESKTOP is not set"
        failed=1
    fi

    if detect_qdbus >/dev/null 2>&1; then
        ok "D-Bus CLI available: ${QDBUS[0]}"
    else
        warn "No qdbus6/qdbus found"
        failed=1
    fi

    if list_activity_ids >/dev/null 2>&1; then
        ok "Activity Manager reachable"
    else
        warn "Activity Manager unavailable"
        failed=1
    fi

    if (( failed == 0 )); then
        ok "Verification passed"
    else
        warn "Verification completed with failures"
        return 1
    fi
}
