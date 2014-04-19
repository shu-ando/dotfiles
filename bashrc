# ~/.bashrc: executed by bash(1) for non-login shells.

# call /etc/bashrc
if [[ -f /etc/bashc ]]; then
	. /etc/bashrc
fi

# uname settings
#uname 022

# bash settings
#shopt -s globstar
shopt -s checkwinsize
shopt -s histappend

# Prompt Command settings
if [[ "`id -u`" -eq 0 ]]; then
	PS1="\[\e[38;5;197m\]\u@\h\[\e[0m\] \[\e[38;5;081m\]\t\[\e[0m\] \[\e[38;5;228m\]\w\[\e[0m\] \! \n\\$ "
else
	PS1="\[\e[38;5;085m\]\u@\h\[\e[0m\] \[\e[38;5;081m\]\t\[\e[0m\] \[\e[38;5;228m\]\w\[\e[0m\] \! \n\\$ "
fi

# dircolors settings
if [[ -x /usr/bin/dircolors ]]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)"
fi

# alias settings
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

# call ~/.bashrc.local
if [[ -f ~/.bashrc.local ]]; then
	. /etc/.bashrc.local
fi

