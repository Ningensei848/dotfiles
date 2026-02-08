# ----------------------------------------------------------------------------
# This script is sourced from `.zshrc`
# ----------------------------------------------------------------------------

# env variables & PATH -------------------------------------------------------
# --- chezmoi
path+=("$HOME/bin")

# --- local bin (for uv, various tools)
path+=("$HOME/.local/bin")

# --- rust (cargo)
# .cargo/env があれば読み込む（これでPATHも通る）、なければ直接binを追加
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
else
  path+=("$HOME/.cargo/bin")
fi

# --- proto
# cf. https://moonrepo.dev/docs/proto/install
export PROTO_HOME="$HOME/.proto"
path+=("$PROTO_HOME/shims")
path+=("$PROTO_HOME/bin")


# options --------------------------------------------------------------------
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt share_history
setopt autocd
setopt extendedglob
setopt noflowcontrol
setopt correct
unsetopt beep

# define $fpath for completion -----------------------------------------------
completions_dir="$HOME/.zsh/completions"

# if completions are not generated, ...
if [[ ! -r "$completions_dir" ]]; then
  mkdir -p $completions_dir
fi

fpath=($completions_dir $fpath)
