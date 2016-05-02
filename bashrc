
# Aliases

alias sizes='du -sh * | sort -hr'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -al --color --group-directories-first'
alias please='sudo $(history -p \!\!)'

# Set Prompt

export PS1="\[$(tput setaf 7)\]\[$(tput bold)\][\[$(tput setaf 5)\]\u@\h \[$(tput setaf 6)\]\w\[$(tput setaf 7)\]\[$(tput sgr0)\]]\\$ \[$(tput sgr0)\]"

# VIM Mode

set -o vi
