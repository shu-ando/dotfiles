# ~/.bashrc: executed by bash(1) for non-login shells.

# bash settings.
#shopt -s globstar
shopt -s checkwinsize
shopt -s histappend

# Prompt Command settings.
if [ "`id -u`" -eq 0 ]; then
  PS1="\[\e[38;5;197m\]\u@\h\[\e[0m\] \[\e[38;5;081m\]\t\[\e[0m\] \[\e[38;5;228m\]\w\[\e[0m\] \! \n\\$ "
else
  PS1="\[\e[38;5;085m\]\u@\h\[\e[0m\] \[\e[38;5;081m\]\t\[\e[0m\] \[\e[38;5;228m\]\w\[\e[0m\] \! \n\\$ "
fi

# alias settings
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    # some more ls aliases
    alias ll='ls -alf'
    alias la='ls -a'
    alias l='ls -CF'
    alias l.='ls -d .*'
	alias ll.='ls -ld .*'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

