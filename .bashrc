# .bashrc

#################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

############################# User editon ###################################

####  alias

alias bashrc-backup='cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) .bashrc backups-bashrc/bashrc-backup'
alias bashprofile-backup='cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) .bash_profile backups-bashprofile/bashprofile-backup'
alias cls='clear'
alias df='df -h'
alias ps='ps --sort=start_time'
alias del='rm -i'

# ヒント１：パスが長かったりすると毎回打つのは面倒 => プロジェクトごとにエイリアスを設定すると楽になる
# alias some-project="/path/to/some-project"
# ヒント２：gitコマンドはオプションも含めてalias登録しておくといいかも？
# alias gitlgo="git log --graph --oneline"
# alias gitdno="git diff --name-only"
# alias gitcae="git commit --allow-empty"
# alias gitlf="git log --format=format:'%C(red)%h %C(yellow)[%ai] %C(blue)&lt;%an&gt; %C(green)%s %C(yellow)(%ar)'"


####  functions

####  other OR temp
