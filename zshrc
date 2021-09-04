SHORT_HOSTNAME=${HOST/.*/}
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ ! -d $CACHE_DIR ]] && mkdir -p $CACHE_DIR

# Env variables

export PATH=~/bin:$PATH
export EDITOR=vim
export MANWIDTH=80
export PAGER=less
export FZF_DEFAULT_COMMAND="rg --files --hidden --iglob '!**/.git/'"
export SCREENRC="${XDG_CONFIG_HOME:-$HOME/.config}/screen/screenrc"
export TEXMFHOME="${XDG_CONFIG_HOME:-$HOME/.config}/texmf"

# Aliases

alias ls='ls -hal --group-directories-first --color=always'
alias fuck='sudo $(!!)'
alias clipcopy='xclip -in -selection clipboard'
alias clippaste='xclip -out -selection clipboard'
alias grep='grep --color=auto --exclude-dir=.git'
alias d1='ssh docker1'
alias d1a='ssh -o "ForwardAgent=yes" docker1'
alias d2a="ssh \
	-o 'ForwardAgent=yes' \
	-o 'RemoteForward=/run/user/1000/gnupg/S.gpg-agent \
		$(gpgconf --list-dirs | grep agent-extra-socket | cut -d : -f 2)' \
	docker2"
alias rust-gdb="rust-gdb -x /usr/share/gdb-dashboard/.gdbinit"
alias fvim="nvim \$(fzf)"
alias kp="kill -9 \$(ps -eo 'pid,pcpu,user,start,cmd' --sort '-pcpu' | sed 1d | fzf -m --header '[kill processes]' | awk '{print $1}')"

if id -nzG $USER | grep -qzx "docker"
then
    alias dc="$(which docker-compose)"
else
    alias dc="sudo $(which docker-compose)"
fi

# General options

setopt correct
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt interactivecomments
setopt auto_cd

# History options

HISTFILE="${CONFIG_DIR}/history"
HISTSIZE=50000
SAVEHIST=10000

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt extended_history
setopt inc_append_history
setopt hist_verify

# Completions

setopt always_to_end
setopt complete_in_word

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $CACHE_DIR
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-dirs-first true

zstyle ':completion:*:*:*:*:*' menu select # always show the suggestion list
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args --width=100"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

autoload -U compinit
compinit -d "$CACHE_DIR/compdump-$SHORT_HOSTNAME-$ZSH_VERSION"

# auto-escaping of shell chars when typing/pasting a url

autoload -Uz bracketed-paste-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

# start or reuse existing ssh agent

AGENT_CACHE="$CACHE_DIR/ssh-agent-$SHORT_HOSTNAME"
AGENT_FORWARDING_SYMLINK="$CACHE_DIR/forwarded-agent-socket"

function start_ssh_agent()
{
	ssh-agent -s > $AGENT_CACHE
	chmod 600 $AGENT_CACHE
	. $AGENT_CACHE > /dev/null
}

if [[ -n "$SSH_AUTH_SOCK" ]]
then
	if [[ $SSH_AUTH_SOCK != $AGENT_FORWARDING_SYMLINK ]]
	then
		ln -sf $SSH_AUTH_SOCK $AGENT_FORWARDING_SYMLINK
		export SSH_AUTH_SOCK=$AGENT_FORWARDING_SYMLINK
	fi
elif [[ -z "$SSH_CLIENT" ]]
then
	if [[ -f $AGENT_CACHE ]]
	then
		. $AGENT_CACHE > /dev/null
		ps -p $SSH_AGENT_PID | grep -q ssh-agent || start_ssh_agent
	else
		start_ssh_agent
	fi
fi

unfunction start_ssh_agent
unset AGENT_CACHE

# start gpg agent if not already running

AGENT_SOCK=$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)

if [[ ! -S $AGENT_SOCK ]];
then
	gpg-agent --daemon --use-standard-socket &>/dev/null
fi

export GPG_TTY=$TTY
unset AGENT_SOCK

# Prompt setup

zstyle ':vcs_info:git:*' formats '%b'
autoload -Uz vcs_info colors
precmd_functions=(vcs_info)
colors

typeset -AHg FG BG
for code in {0..255}
do
    FG[$code]="%{[38;5;${code}m%}"
    BG[$code]="%{[48;5;${code}m%}"
done

function color_pallete()
{
	for code in {0..254}
	do
		print -P -- "$code: %{$FG[$code]%}test foreground%{$reset_color%}\t\
%{$BG[$code]%} test background %{$reset_color%}"
	done
}

function git_prompt_info()
{
	STATUS=$(git status -b --porcelain 2>&1)

	[[ $? != 0 ]] && return

	echo -n "%{$bold_color%} on %{$FG[198]%}\ue0a0 $vcs_info_msg_0_ "

	SYMBOLS=""

	if $(echo $STATUS | grep -q '^[ MARC]M'); then SYMBOLS="$SYMBOLS!"; fi
	if $(echo $STATUS | grep -q '^??'); then SYMBOLS="$SYMBOLS?"; fi
	if $(echo $STATUS | grep -q '^[ MARC]D'); then SYMBOLS="$SYMBOLS\u2718"; fi
	if $(echo $STATUS | grep -q '^\(A[ AMD]\|M[ MD ]\)'); then SYMBOLS="$SYMBOLS+"; fi

	if $(echo $STATUS | grep -Eq '^## [^ ]+ .*ahead'); then
		SYMBOLS="$SYMBOLS\u2b6d"
	elif $(echo $STATUS | grep -Eq '^## [^ ]+ .*behind'); then
		SYMBOLS="$SYMBOLS\u2b6b"
	fi

	if [[ -z $SYMBOLS ]]
	then
		echo -n "%{$FG[40]%}[\u2714]"
	else

		echo -n "%{$FG[196]%}[$SYMBOLS]"
	fi

	echo -n "%{$reset_color%}"
}

function display_prompt()
{
	echo -n "
%{$reset_color%}%{$terminfo[bold]%}\
$([[ -n $SSH_CONNECTION ]] && echo " %{$FG[45]%}%n%{$FG[135]%}@%{$FG[198]%}$SHORT_HOSTNAME %{$reset_color$terminfo[bold]%}in")\
%{$FG[69]%} ${PWD/#$HOME/~}\
%{$reset_color%}$(git_prompt_info)\
%{$reset_color%}"

	JOB_COUNT=$(jobs | grep -v '(pwd now' | wc -l)

	if [ $JOB_COUNT != 0 ];
	then
		echo -n " %{$FG[208]%}[$JOB_COUNT job"
		[ $JOB_COUNT != 1 ] && echo -n "s"
		echo -n "]"
	fi

	echo -n "
 $([[ $KEYMAP = 'vicmd' ]] && echo $NORMAL_PROMPT || echo $INSERT_PROMPT)\
 %{$reset_color%}"
	# \u3009 \u29fd \u27e9 \u2771 \u276f \u276d \u2794 
}

setopt prompt_subst

PROMPT="\$(display_prompt)"
NORMAL_PROMPT="%{$FG[166]%}\u276f\u276f\u276f"
INSERT_PROMPT="%{$FG[45]%}\u276f%{$FG[135]%}\u276f%{$FG[198]%}\u276f"

# vi-mode setup

KEYTIMEOUT=10

function zle-keymap-select()
{
	zle reset-prompt
	zle -R
}

zle -N zle-keymap-select

bindkey -v
bindkey -M viins 'kj' vi-cmd-mode
bindkey -M vicmd '\e' vi-add-next

# v to edit the command line in vim

zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# add back some standard non-vi mode bindings

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^e' end-of-line
bindkey '^[OF' end-of-line

bindkey "^[m" copy-prev-shell-word

# Colored less man pages

export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 0; tput setab 7)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)

function try_source_plugin()
{
	[[ -f /usr/share/zsh/plugins/$1/$1.zsh ]] && . /usr/share/zsh/plugins/$1/$1.zsh
}

try_source_plugin zsh-autosuggestions
try_source_plugin zsh-syntax-highlighting
try_source_plugin zsh-history-substring-search

# Source machine-specific configuration

[[ -f $CONFIG_DIR/.zshrc.local ]] && . $CONFIG_DIR/.zshrc.local

unset CACHE_DIR
unset CONFIG_DIR
