# hikari-zsh -  A pure and minimalistic zsh with special shortcuts
#
# Copyright (c) 2019 by Christian Rebischke <chris@nullday.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http: #www.gnu.org/licenses/
#
#======================================================================
# Author: Christian Rebischke
# Email : chris@nullday.de
# Github: www.github.com/Shibumi

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
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes false
zstyle ':vcs_info:git*' formats "%8.8i %b "
zstyle ':vcs_info:git*' actionformats "%8.8i %b %F{red}%a %m%f "
zstyle ':vcs_info:git*' patch-format "%8.8p "
zstyle ':vcs_info:svn*:*' get-revision true
zstyle ':vcs_info:svn*:*' check-for-changes false
zstyle ':vcs_info:svn*' formats "%b %m "
zstyle ':vcs_info:svn*' actionformats "%b/%a %m "
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
zle -N insert-files
zstyle ':completion:*:*:cd:*' tag-order '!users' -

# completion
function grmlcomp () {
    # Make sure the completion system is initialised
    (( ${+_comps} )) || return 1
    # allow one error for every three characters typed in approximate completer
    zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
    # don't complete backup files as executables
    zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'
    # start menu completion only if it could find no unambiguous initial string
    zstyle ':completion:*:correct:*'       insert-unambiguous true
    zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
    zstyle ':completion:*:correct:*'       original true
    # activate color-completion
    zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
    # format on completion
    zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
    # automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
    # zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
    # insert all expansions for expand completer
    zstyle ':completion:*:expand:*'        tag-order all-expansions
    zstyle ':completion:*:history-words'   list false
    # activate menu
    zstyle ':completion:*:history-words'   menu yes
    # ignore duplicate entries
    zstyle ':completion:*:history-words'   remove-all-dups yes
    zstyle ':completion:*:history-words'   stop yes
    # match case insensitive
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
    # separate matches into groups
    zstyle ':completion:*:matches'         group 'yes'
    zstyle ':completion:*'                 group-name ''
    if [[ "$NOMENU" -eq 0 ]] ; then
        # if there are more than 5 options allow selecting from a menu
        zstyle ':completion:*'               menu select=5
    else
        # don't use any menus at all
        setopt no_auto_menu
    fi
    zstyle ':completion:*:messages'        format '%d'
    zstyle ':completion:*:options'         auto-description '%d'
    # describe options in full
    zstyle ':completion:*:options'         description 'yes'
    # on processes completion complete all user processes
    zstyle ':completion:*:processes'       command 'ps -au$USER'
    # offer indexes before parameters in subscripts
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
    # provide verbose completion information
    zstyle ':completion:*'                 verbose true
    # recent (as of Dec 2007) zsh versions are able to provide descriptions
    # for commands (read: 1st word in the line) that it will list for the user
    # to choose from. The following disables that, because it's not exactly fast.
    zstyle ':completion:*:-command-:*:'    verbose false
    # set format for warnings
    zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
    # define files to ignore for zcompile
    zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
    zstyle ':completion:correct:'          prompt 'correct to: %e'
    # Ignore completion functions for commands you don't have:
    zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
    # Provide more processes in completion of programs like killall:
    zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
    # complete manual by their section
    zstyle ':completion:*:manuals'    separate-sections true
    zstyle ':completion:*:manuals.*'  insert-sections   true
    zstyle ':completion:*:man:*'      menu yes select
    # Search path for sudo completion
    zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                               /usr/local/bin  \
                                               /usr/sbin       \
                                               /usr/bin        \
                                               /sbin           \
                                               /bin            \
                                               /usr/X11R6/bin

    # provide .. as a completion
    zstyle ':completion:*' special-dirs ..
    # run rehash on completion so new installed program are found automatically:
    function _force_rehash () {
        (( CURRENT == 1 )) && rehash
        return 1
    }
    # correction
    # some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
    if [[ "$NOCOR" -gt 0 ]] ; then
        zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
        setopt nocorrect
    else
        # try to be smart about when to use what completer...
        setopt correct
        zstyle -e ':completion:*' completer '
            if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
                _last_try="$HISTNO$BUFFER$CURSOR"
                reply=(_complete _match _ignored _prefix _files)
            else
                if [[ $words[1] == (rm|mv) ]] ; then
                    reply=(_complete _files)
                else
                    reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
                fi
            fi'
    fi
    # command for process lists, the local web server details and host completion
    zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'
    # Some functions, like _apt and _dpkg, are very slow. We can use a cache in
    # order to speed things up
    if [[ ${GRML_COMP_CACHING:-yes} == yes ]]; then
        GRML_COMP_CACHE_DIR=${GRML_COMP_CACHE_DIR:-${ZDOTDIR:-$HOME}/.cache}
        if [[ ! -d ${GRML_COMP_CACHE_DIR} ]]; then
            command mkdir -p "${GRML_COMP_CACHE_DIR}"
        fi
        zstyle ':completion:*' use-cache  yes
        zstyle ':completion:*:complete:*' cache-path "${GRML_COMP_CACHE_DIR}"
    fi
    # host completion
    if [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] ; then
        [[ -r ~/.ssh/config ]] && _ssh_config_hosts=(${${(s: :)${(ps:\t:)${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }}}:#*[*?]*}) || _ssh_config_hosts=()
        [[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
        [[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
    else
        _ssh_config_hosts=()
        _ssh_hosts=()
        _etc_hosts=()
    fi
    hosts=(
        $(hostname)
        "$_ssh_config_hosts[@]"
        "$_ssh_hosts[@]"
        "$_etc_hosts[@]"
        localhost
    )
    zstyle ':completion:*:hosts' hosts $hosts
    # see upgrade function in this file
    compdef _hosts upgrade
}
# completion dump file
COMPDUMPFILE=${COMPDUMPFILE:-${ZDOTDIR:-${HOME}}/.zcompdump}
# activate completion
grmlcomp
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
    local WORDCHARS='*?-[]~=&;!#$%^(){}<>'
    zle backward-kill-word
}
zle -N backward-kill-dir

# backward half word
backward-half-word () {
    local WORDCHARS='*?-[]~=&;!#$%^(){}<>'
    zle backward-word
}
zle -N backward-half-word

# forward half word
forward-half-word () {
    local WORDCHARS='*?-[]~=&;!#$%^(){}<>'
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
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [ -z "$(command git status --porcelain --ignore-submodules -unormal)" ]; then
            echo "green"
        else
            echo "yellow"
        fi
    else
        echo "blue"
    fi

}

NEWLINE=$'\n'
precmd() {
    vcs_info
    FIRST_PROMPT="%(!.%F{red}root%f.%F{green}$USER%f) %B%F{$prompt_color}%m%f%b %F{$(prompt_dir_writeable)}%~%f %* %F{$(prompt_git_dirty)}${vcs_info_msg_0_}%f %(1j.%j.)"
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
bindkey '^[^?' backward-kill-dir
bindkey '\e[1;3D' backward-half-word
bindkey '\e[1;3C' forward-half-word

# load zsh-syntax-highlighting
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# load skim completion and keybindings
[ -f /usr/share/skim/key-bindings.zsh ] && source /usr/share/skim/key-bindings.zsh
[ -f /usr/share/skim/completion.zsh ] && source /usr/share/skim/completion.zsh

# load $HOME/.zshrc.local to overwrite this zshrc
[[ -r ${HOME}/.zshrc.local ]] && source ${HOME}/.zshrc.local
