# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Shell
export HISTSIZE=9999
export HISTFILESIZE=99999
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -s cdspell
export HISTCONTROL="ignoreboth"
#export HISTIGNORE="&:ls:[bf]g:exit"
#export HISTIGNORE="mc"
shopt -s cmdhist
export HISTTIMEFORMAT='%d.%m.%Y %H:%M:%S '
shopt -s checkwinsize
