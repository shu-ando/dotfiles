# TERM settings
TERM="xterm-256color"
export TERM

# PATH settings
GOROOT="/usr/local/go"
GOPATH="$HOME/go"
PATH="$PATH:$HOME/bin:$GOPATH/bin:$GOROOT/bin"
export GOROOT GOPATH PATH

# history settings
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=9999
HISTTIMEFORMAT='%Y/%m/%d %T '
HISTIGNORE="fg*:bg*:history*"
export HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT HISTIGNORE

# editor
EDITOR=$(which vim)
export EDITOR

# less settings
LESS='-R'
export LESS

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

