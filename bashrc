# ~/.bashrc: executed by bash(1) for non-login shells.
[[ $- != *i* ]] && return

# BASH SETTINGS
#shopt -s globstar
shopt -s checkwinsize
shopt -s histappend

# PROMPT SETTINGS
function parse_git_branch() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1] /' 
}

if [[ "`id -u`" -eq 0 ]]; then
	PS1="\[\e[38;5;197m\]\u@\h\[\e[0m\] \[\e[38;5;116m\]\t\[\e[0m\]\[\e[38;5;158m\] #\$?:\!\[\e[0m\] \[\e[38;5;223m\]\$(parse_git_branch)\[\e[0m\]\[\e[38;5;228m\]\w\[\e[0m\]\n\\$ "
else
	PS1="\[\e[38;5;085m\]\u@\h\[\e[0m\] \[\e[38;5;116m\]\t\[\e[0m\]\[\e[38;5;158m\] #\$?:\!\[\e[0m\] \[\e[38;5;223m\]\$(parse_git_branch)\[\e[0m\]\[\e[38;5;228m\]\w\[\e[0m\]\n\\$ "
fi

# dircolors settings
if [[ ( -x /usr/bin/dircolors ) && ( -r ~/.dircolors )  ]] ; then
	eval "$(dircolors -b ~/.dircolors)"
fi

# alias settings
alias ls='ls -h --color=auto --time-style=+%Y-%m-%dT%H:%M:%S'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias l='ls -F'
alias ll='l -l'
alias la='ll -a'
alias ld='la | grep ^d'
alias lf='la | grep -v ^d'
alias l.='la -d .*'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# call ~/.bashrc.local
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

