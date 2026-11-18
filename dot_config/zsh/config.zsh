# Managed configuration uses ~/.config; cache/data/state honor XDG overrides.
source "$HOME/.local/share/dotfiles/events.sh"

# Prefer the versions managed by chezmoi; keep existing language managers usable.
typeset -U path fpath
export PROTO_HOME="${PROTO_HOME:-$HOME/.proto}"
path=("$HOME/.local/bin" "$HOME/bin" "$PROTO_HOME/shims" "$PROTO_HOME/bin" "$HOME/.cargo/bin" $path)
export PATH
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export SHELDON_CONFIG_DIR="$HOME/.config/sheldon"
export SHELDON_DATA_DIR="$XDG_DATA_HOME/sheldon"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Retain the existing history file during migration.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history hist_ignore_all_dups hist_reduce_blanks hist_no_store share_history
setopt autocd extendedglob noflowcontrol correct
unsetopt beep
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if ! mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_DATA_HOME/zsh/completions"; then
  dotfiles_event DIRECTORY_CREATE_FAILED zsh 1 unavailable
fi
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)

# Generate initialization from the current binary. No global source override,
# generated init files in Git, or timestamp-based cache invalidation.
_dotfiles_init() {
  local tool="$1" init_code rc
  shift
  if (( ! $+commands[$tool] )); then
    dotfiles_event COMMAND_MISSING "$tool" 127 basic-shell
    return 0
  fi
  if init_code=$("$tool" "$@"); then
    if [[ -z "$init_code" ]]; then
      dotfiles_event INIT_EMPTY "$tool" 1 basic-shell
      return 0
    fi
    if eval "$init_code"; then
      dotfiles_event INIT_SUCCEEDED "$tool" 0 ready
      return 0
    else
      rc=$?
      dotfiles_event INIT_EVAL_FAILED "$tool" "$rc" basic-shell
    fi
  else
    rc=$?
    dotfiles_event INIT_GENERATION_FAILED "$tool" "$rc" basic-shell
  fi
}

_dotfiles_init sheldon source
if (( $+commands[proto] )); then
  _dotfiles_init proto activate zsh
fi
_dotfiles_init starship init zsh
unfunction _dotfiles_init
