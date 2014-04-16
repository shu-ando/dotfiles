# TERM settings
TERM="xterm-256color"
export TERM

# GOPATH settings
GOROOT="/usr/local/go"
GOPATH="$HOME/go"
PATH="$PATH:$HOME/bin:$GOROOT/bin:$GOPATH/bin"
export GOROOT GOPATH PATH

if [ "`id -u`" -eq 0 ]; then
  PS1="\[\e[38;5;197m\]\u@\h\[\e[0m\] \[\e[38;5;081m\]\t\[\e[0m\] \[\e[38;5;228m\]\w\[\e[0m\] \! \n\\$ "
else
  PS1="\[\e[38;5;085m\]\u@\h\[\e[0m\] \[\e[38;5;081m\]\t\[\e[0m\] \[\e[38;5;228m\]\w\[\e[0m\] \! \n\\$ "
fi
export PS1

# history settings
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=9999
HISTTIMEFORMAT='%Y/%m/%d %T '
HISTIGNORE="fg*:bg*:history*"
export HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT HISTIGNORE

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

