# ----------------------------------------------------------------------------
# This script is sourced from `.zshrc`
# ----------------------------------------------------------------------------

# options
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
  mkdir $completions_dir
  # TODO: ここでその他の completions を生成するスクリプトを走らせる
  # hogehoge fugafuga ...
fi

fpath=($completions_dir $fpath)

