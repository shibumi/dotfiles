# hikari-zsh -  A pure and minimalistic zsh with special shortcuts
#
# Copyright (c) 2021 by Christian Rebischke <chris@shibumi.dev>

# load $HOME/.zshrc.pre to overwrite defaults
[[ -r ${HOME}/.zshrc.pre ]] && source ${HOME}/.zshrc.pre

# Colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# protect special characters
export LC_CTYPE="en_US.UTF-8"

# Setopts
# allow prompt substitution
setopt prompt_subst
# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history
# import new commands from the history file also in other zsh-session
setopt share_history
# save each command's beginning timestamp and the duration to the history file
setopt extended_history
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups
# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace
# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob
# display PID when suspending processes as well
setopt longlistjobs
# try to avoid the 'zsh: no matches found...'
setopt nonomatch
# report the status of backgrounds jobs immediately
setopt notify
# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all
# not just at the end
setopt completeinword
# Don't send SIGHUP to background processes when the shell exits.
setopt nohup
# make cd push the old directory onto the directory stack.
setopt auto_pushd
# avoid "beep"ing
setopt nobeep
# don't push the same dir twice.
setopt pushd_ignore_dups
# * shouldn't match dotfiles. ever.
setopt noglobdots
# use zsh style word splitting
setopt noshwordsplit
# enable dir-stack
setopt autopushd pushdminus pushdsilent pushdtohome
# Remove duplicate entries
setopt pushdignoredups
# Shortcuts for directories e.g. hash -d
setopt autocd
# enable interactivecomments
setopt interactivecomments
# Disable flowcontrol
stty -ixon

# Autoload
autoload -Uz colors && colors
autoload -Uz vcs_info
autoload -Uz compinit

# History Settings
HISTSIZE=1000000
SAVEHIST=9000000
HISTFILE=~/.zsh_history
TIMEFMT="'$fg[green]%J$reset_color' time: $fg[blue]%*Es$reset_color, cpu: $fg[blue]%P$reset_color"
REPORTTIME=10

# zstyles
zstyle ':completion:*' menu select
zstyle ':vcs_info:*' enable git svn
zstyle ':completion::complete:*' use-cache 1 # enables completion caching
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes false
zstyle ':vcs_info:git*' formats "%8.8i %b "
zstyle ':vcs_info:git*' actionformats "%8.8i %b %F{red}%a %m%f "
zstyle ':vcs_info:git*' patch-format "%8.8p "
zstyle ':vcs_info:svn*:*' get-revision true
zstyle ':vcs_info:svn*:*' check-for-changes false
zstyle ':vcs_info:svn*' formats "%b %m "
zstyle ':vcs_info:svn*' actionformats "%b/%a %m "

# completion dump file
COMPDUMPFILE=${COMPDUMPFILE:-${ZDOTDIR:-${HOME}}/.zcompdump}
# activate completion
compinit -d ${COMPDUMPFILE} || print 'Notice: no compinit available :('

# Smart Functions
# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

# Behaviour
# custom keybindings for string operations
toggleSingleString() {
  LBUFFER=`echo $LBUFFER | sed "s/\(.*\) /\1 '/"`
  RBUFFER=`echo $RBUFFER | sed "s/\($\| \)/' /"`
  zle redisplay
}
zle -N toggleSingleString

toggleDoubleString() {
  LBUFFER=`echo $LBUFFER | sed 's/\(.*\) /\1 "/'`
  RBUFFER=`echo $RBUFFER | sed 's/\($\| \)/" /'`
  zle redisplay
}
zle -N toggleDoubleString

clearString() {
  LBUFFER=`echo $LBUFFER | sed 's/\(.*\)\('"'"'\|"\).*/\1\2/'`
  RBUFFER=`echo $RBUFFER | sed 's/.*\('"'"'\|"\)\(.*$\)/\1\2/'`
  zle redisplay
}
zle -N clearString

#overwrite alt+backspace
backward-kill-dir () {
    local WORDCHARS='*?-[]~=&;!#$%^(){}<>|_'
    zle backward-kill-word
}
zle -N backward-kill-dir

# backward half word
backward-half-word () {
    local WORDCHARS='*?-[]~=&;!#$%^(){}<>|_.'
    zle backward-word
}
zle -N backward-half-word

# forward half word
forward-half-word () {
    local WORDCHARS='*?-[]~=&;!#$%^(){}<>|_.'
    zle forward-word
}
zle -N forward-half-word

# run command line as user root via sudo:
function sudo-command-line () {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line

# insert datetime on key shortcut
function insert-datestamp () { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp

# get last modified file
function get-last-modified-file () {
	LAST_FILE=$(\ls -t1p | grep -v / | head -1)
	LBUFFER+=${(%):-$LAST_FILE}
}
zle -N get-last-modified-file

# jump behind the first word on the cmdline
# useful to add options.
function jump_after_first_word () {
    local words
    words=(${(z)BUFFER})

    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}+1
    fi
}
zle -N jump_after_first_word

# Custom Prompt

if [[ ! -f ~/.zshcolor ]]; then
	declare -a colors
	colors=('cyan' 'green' 'yellow' 'magenta' 'red' 'blue')
	host_hash=$(hostnamectl --static | md5sum | tr -d '[a-fA-F]' | cut -d ' ' -f 1 | head -c 5)
	prompt_color=$colors[$((host_hash % ${#colors[@]} + 1))]
	echo -n $prompt_color > ~/.zshcolor
else
	prompt_color=$(cat ~/.zshcolor)
fi

prompt_dir_writeable() {
    if [ -w $PWD ]; then
        echo "blue"
    else
        echo "red"
    fi
}

prompt_git_dirty() {
    if ! command -v git &> /dev/null; then
	    exit
    fi
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [ -z "$(command git status --porcelain --ignore-submodules -unormal)" ]; then
            echo "green"
        else
            echo "yellow"
        fi
    else
        echo "red"
    fi
}

prompt_get_namespace() {
	return
	if ! command -v kubens &> /dev/null; then
		exit
	fi
	echo "$(kubens -c)"
}

prompt_get_context() {
	return
	if ! command -v kubectx &> /dev/null; then
		exit
	fi
	prompt_context="$(kubectx -c)"
	if [[ "$prompt_context" == "gmh-prod" ]]; then
		echo %F{red}$prompt_context%f
	else
		echo %F{blue}$prompt_context%f
	fi
}

prompt_get_gcloud_context() {
    if ! command -v gcloud &> /dev/null; then
        exit
    fi
    echo "$(gcloud config get-value project)"
 }

NEWLINE=$'\n'
precmd() {
    vcs_info
    FIRST_PROMPT="%(!.%F{red}root%f.%F{green}$USER%f) %F{$prompt_color}%m%f %F{$(prompt_dir_writeable)}%~%f %* %F{$(prompt_git_dirty)}${vcs_info_msg_0_}%f $(prompt_get_gcloud_context) %F{blue}$(prompt_get_context) %F{cyan}$(prompt_get_namespace)%f %(1j.%j.)"
}
PROMPT='$FIRST_PROMPT${NEWLINE}%(?.%F{green}.%F{red})❯%f '

# Bindkeys
bindkey -e
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey "^xd" insert-datestamp
bindkey "^xs" sudo-command-line
bindkey "^x1" jump_after_first_word
bindkey "^x'" toggleSingleString
bindkey '^x"' toggleDoubleString
bindkey '^x;' clearString
bindkey '^xc' copy-prev-shell-word
bindkey '^xl' get-last-modified-file
bindkey '^[^?' backward-kill-dir
bindkey '\e[1;3D' backward-half-word
bindkey '\e[1;3C' forward-half-word

# load zsh-syntax-highlighting
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# load fzf completion and keybindings
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# load $HOME/.zshrc.local to overwrite this zshrc
[[ -r ${HOME}/.zshrc.local ]] && source ${HOME}/.zshrc.local
