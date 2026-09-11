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
    local id

    if id="$(find_activity_id "$name")"; then
        warn "Activity already exists: $name ($id)"
        return 0
    fi

    log "Creating activity: $name"

    id="$(dbus_call AddActivity "$name")"

    if [[ -z "$id" ]]; then
        die "Activity Manager returned an empty activity ID"
    fi

    ok "Created activity: $name ($id)"
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

current_activity() {
    local id name

    id="$(dbus_call CurrentActivity)"

    if [[ -z "$id" ]]; then
        die "Activity Manager returned no current activity"
    fi

    name="$(activity_name "$id" || true)"

    if [[ -n "$name" ]]; then
        printf '%s\t%s\n' "$id" "$name"
    else
        printf '%s\n' "$id"
    fi
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

    log "Removing activity: $name ($id)"

    dbus_call RemoveActivity "$id"

    ok "Removed activity: $name"
}
