#!/usr/bin/env bash

SERVICE="org.kde.ActivityManager"
OBJECT="/ActivityManager/Activities"
INTERFACE="org.kde.ActivityManager.Activities"

QDBUS=()

detect_qdbus() {
    if command -v qdbus-qt6 >/dev/null 2>&1; then
        QDBUS=(qdbus-qt6)
    elif command -v qdbus >/dev/null 2>&1; then
        QDBUS=(qdbus)
    else
        die "qdbus6 or qdbus is required. Install KDE D-Bus command-line tools."
    fi
}

dbus_call() {
    if [[ ${#QDBUS[@]} -eq 0 ]]; then
        detect_qdbus
    fi

    "${QDBUS[@]}" "$SERVICE" "$OBJECT" "$@"
}

check_dbus() {
    detect_qdbus
    ok "D-Bus CLI: ${QDBUS[0]}"

    if dbus_call >/dev/null 2>&1; then
        ok "Activity Manager D-Bus service is reachable"
    else
        die "Cannot reach KDE Activity Manager over D-Bus"
    fi
}

check_activity_manager() {
    detect_qdbus

    log "Activity Manager service: $SERVICE"
    log "Object: $OBJECT"
    log "Interface: $INTERFACE"

    log "Available D-Bus methods/properties:"
    dbus_call 2>/dev/null || true
}
