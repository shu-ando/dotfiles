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

# less settings
LESS='-R'
export LESS

# # proxy settings
# username=***
# password=***
# proxyserver=***
# http_proxy="http://$username:$password@$proxyserver/"
# https_proxy=$http_proxy
# ftp_proxy=$http_proxy
# rsync_proxy=$http_proxy
# all_proxy=$http_proxy
# no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
# HTTP_PROXY=$http_proxy
# HTTPS_PROXY=$https_proxy
# FTP_PROXY=$ftp_proxy
# RSYNC_PROXY=$rsync_proxy
# ALL_PROXY=$all_proxy
# NO_PROXY=$no_proxy
# export http_proxy https_proxy ftp_proxy rsync_proxy all_proxy no_proxy
# export HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY NO_PROXY

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

