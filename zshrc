export ZSH=~/.oh-my-zsh

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd.mm.yyyy"

zstyle :omz:plugins:ssh-agent identities id_rsa
plugins=(git ssh-agent gpg-agent vi-mode)

source $ZSH/oh-my-zsh.sh

# Env variables

export PATH=~/bin:$PATH
export EDITOR=vim

# Aliases

alias ls='ls -hal --group-directories-first --color=always'

# Stuff for generating the fancy vim style git prompt

local current_dir='${PWD/#$HOME/~}'

YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}✖︎"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}●"

local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

function get_prompt()
{
	if (( $? == 0 )); then

		echo "%(?.%{$terminfo[bold]$fg[green]%}"
	else
		echo "$? "
	fi
}

PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$fg[cyan]%}%n \
%{$fg[white]%}at \
%{$fg[green]%}$HOST \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
${git_info} \
%{$fg[white]%}[%*]
%(?.%{$terminfo[bold]$fg[green]%}.%{$terminfo[bold]$fg[red]%})→ %{$reset_color%}"

# Get rid of RPS1 when accepting a command line (no trailing historical INSERT/NORMAL)

setopt transientrprompt

KEYTIMEOUT=1
NORMAL_PROMPT="%{$fg_bold[magenta]%}[ NORMAL ]%{$reset_color%}"
INSERT_PROMPT="%{$fg_bold[cyan]%}[ INSERT ]%{$reset_color%}"

function vi_mode_prompt_info()
{
	echo "${${${KEYMAP/vicmd/$NORMAL_PROMPT}/(main|viins)/$INSERT_PROMPT}:-$INSERT_PROMPT}"
}

if [ -f ~/.zshrc.local ]
then
	. ~/.zshrc.local
fi

bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
