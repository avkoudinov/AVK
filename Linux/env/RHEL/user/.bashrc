# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

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
