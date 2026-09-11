#!/usr/bin/env bash

list_activity_ids() {
    dbus_call ListActivities 2>/dev/null
}

activity_name() {
    local id="$1"
    dbus_call ActivityName "$id" 2>/dev/null
}

find_activity_id() {
    local wanted="$1"
    local id name

    while IFS= read -r id; do
        [[ -n "$id" ]] || continue

        name="$(activity_name "$id" || true)"

        if [[ "$name" == "$wanted" ]]; then
            printf '%s\n' "$id"
            return 0
        fi
    done < <(list_activity_ids)

    return 1
}

list_activities() {
    local id name

    while IFS= read -r id; do
        [[ -n "$id" ]] || continue

        name="$(activity_name "$id" || true)"
        printf '%s\t%s\n' "$id" "$name"
    done < <(list_activity_ids)
}

create_activity() {
    local name="$1"

    if find_activity_id "$name" >/dev/null; then
        warn "Activity already exists: $name"
        return 0
    fi

    # NOTE:
    # The Activity Manager creation method differs across Plasma versions.
    # Confirm the available API with:
    #   plasma-installer doctor
    #
    # Do not guess the D-Bus method here. Once confirmed for the supported
    # Plasma versions, put the compatibility handling in this function.

    die "Activity creation is not yet implemented for this Plasma/D-Bus API"
}

ensure_activity() {
    local name="$1"

    if find_activity_id "$name" >/dev/null; then
        ok "Activity exists: $name"
        return 0
    fi

    log "Creating activity: $name"
    create_activity "$name"
}

switch_activity() {
    local name="$1"
    local id

    id="$(find_activity_id "$name")" || {
        warn "Activity not found: $name"
        echo >&2
        echo "Available Activities:" >&2
        list_activities >&2
        return 1
    }

    dbus_call SetCurrentActivity "$id"
    ok "Switched to activity: $name"
}

remove_activity() {
    local name="$1"
    local id

    id="$(find_activity_id "$name")" || {
        warn "Activity not found: $name"
        return 0
    }

    # NOTE:
    # Like creation, activity deletion should be wired to the actual
    # Plasma-version-specific D-Bus API after introspection.
    die "Activity removal is not yet implemented for this Plasma/D-Bus API (ID: $id)"
}
