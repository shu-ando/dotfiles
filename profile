# TERM settings
TERM="xterm-256color"
export TERM

# PATH settings
GOROOT="/usr/local/go"
GOPATH="$HOME/repos"
NDK_ROOT="/opt/android-ndk"
PATH="$PATH:$HOME/bin:$GOPATH/bin:$GOROOT/bin:$NDK_ROOT"
export GOROOT GOPATH PATH NDK_ROOT

# history settings
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=9999
HISTTIMEFORMAT='%Y/%m/%d %T '
HISTIGNORE="fg*:bg*:history*"
export HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT HISTIGNORE

# editor
EDITOR=$(which nvim)
export EDITOR

# less settings
LESS='-R'
export LESS
LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export LESSOPEN

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

