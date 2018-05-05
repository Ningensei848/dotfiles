# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#################################################### default wsl setteings #####################################################################


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#################################################### user add #####################################################################


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# You can isolte your defined alias if you make ".bash_aliases"
# Overwrite this file (".bashrc") by ".bash_aliases"
# aliasだけを独立して「.bash_aliases」に書き込むことも可能
#（このファイルによって「.bashrc」でのalias定義が上書きされる）
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

############################ ningensei848 add  #####################################

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


####  alias

alias bashrc-backup='cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/.bashrc ~/dotfiles/backups-bashrc/.bashrc-backup'
alias bash_profile-backup='cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/.bash_profile ~/dotfiles/backups-bash_profile/.bash_profile-backup'
alias viminfo-backup='cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/.viminfo ~/dotfiles/backups-viminfo/.viminfo-backup'

alias cls='clear'
alias df='df -h'
alias ps='ps --sort=start_time'
alias del='rm -i'
alias docker='sudo docker'
alias dl='docker ps -l -q'
# ヒント１：パスが長かったりすると毎回打つのは面倒 => プロジェクトごとにエイリアスを設定すると楽になる
# alias some-project="/path/to/some-project"

alias home='cd ~'
alias myvenv='source myvenv/bin/activate'
alias start='sudo service ssh start'

# ヒント２：gitコマンドはオプションも含めてalias登録しておくといいかも？
 alias gitlgo="git log --graph --oneline"
 alias gitdno="git diff --name-only"
 alias gitcae="git commit --allow-empty"
 alias gitlf="git log --format=format:'%C(red)%h %C(yellow)[%ai] %C(blue)&lt;%an&gt; %C(green)%s %C(yellow)(%ar)'"


####  functions
# hoge
####  other OR temp
# other
# temp
