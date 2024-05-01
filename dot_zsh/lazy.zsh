
# ----------------------------------------------------------------------------
# This script is sourced from `plugins.toml`
# ----------------------------------------------------------------------------

# env variables --------------------------------------------------------------
export VOLTA_HOME="$HOME/.volta"

# PATH -----------------------------------------------------------------------
# --- chezmoi
path+=("$HOME/bin")
# --- rust
path+=("$HOME/.cargo/env")
# --- rye
source "$HOME/.rye/env"
# --- volta
path+=("$VOLTA_HOME/bin")

# Alias ----------------------------------------------------------------------
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
