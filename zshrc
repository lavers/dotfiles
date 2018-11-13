export ZSH=~/.oh-my-zsh

plugins=(git ssh-agent gpg-agent)

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd.mm.yyyy"

zstyle :omz:plugins:ssh-agent identities id_rsa
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

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() 
{
	zle && { zle reset-prompt; zle -R }
}

# Set Vim Mode

bindkey -v
KEYTIMEOUT=1

vim_normal_mode="%{$fg_bold[magenta]%}[ NORMAL ]%{$reset_color%}"
vim_insert_mode="%{$fg_bold[cyan]%}[ INSERT ]%{$reset_color%}"

vim_mode=$vim_insert_mode

function zle-keymap-select 
{
	vim_mode="${${KEYMAP/vicmd/${vim_normal_mode}}/(main|viins)/${vim_insert_mode}}"
	zle reset-prompt
}

function zle-line-finish
{
	vim_mode=$vim_insert_mode
}

zle -N zle-keymap-select
zle -N zle-line-finish

RPROMPT='${vim_mode}'

