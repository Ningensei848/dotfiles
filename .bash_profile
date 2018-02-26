# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
PS1='[\u@\H \t @\! \w]'

export PATH
export PS1

# .bash_profileから.bashrcを読み込む処理
test -r ~/.bashrc && . ~/.bashrc
