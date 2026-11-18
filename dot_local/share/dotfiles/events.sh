#!/bin/sh
# POSIX shell helpers shared by Zsh startup and Bash maintenance commands.
# Only fixed diagnostic codes and component identifiers may be passed here.
dotfiles_event() {
    (
        umask 077
        event_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
        if ! mkdir -p "$event_dir"; then
            printf '%s\n' 'dotfiles code=LOG_DIRECTORY_FAILED component=diagnostics' >&2
            exit 1
        fi
        printf 'time=%s code=%s component=%s exit=%s attempt=1 recovery=%s pid=%s\n' \
            "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "$2" "$3" "$4" "$$" >> "$event_dir/events.log"
    ) || {
        printf '%s\n' 'dotfiles code=LOG_WRITE_FAILED component=diagnostics' >&2
        return 1
    }
    [ "$3" != 0 ] || return 0
    printf 'dotfiles code=%s component=%s exit=%s recovery=%s\n' "$1" "$2" "$3" "$4" >&2
}
