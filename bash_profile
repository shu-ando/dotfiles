# TERM SETTINGS
TERM="xterm-256color"
export TERM

# HOME SCRIPT PATH SETTINGS
PATH="$PATH:$HOME/bin"
export PATH

# HISTORY SETTINGS 
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=9999
HISTTIMEFORMAT='%Y/%m/%d %T '
HISTIGNORE="fg*:bg*:history*"
export HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT HISTIGNORE

# UNAME SETTINGS 
#uname 022

# LESS SETTINGS
# LESS='-R'
# export LESS
# LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
# export LESSOPEN

# include local settings if it exists
[[ -f "$HOME/.bash_profile.local" ]] && . "$HOME/.bash_profile.local"
# include .bashrc if it exists
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

