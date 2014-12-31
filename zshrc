#!/bin/zsh

umask  022

setopt NO_BG_NICE
setopt COMPLETE_IN_WORD
setopt GLOB_DOTS

limit coredumpsize unlimited

# setup history
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
alias h='fc -f -l 100'

# Adapted from code found at <https://gist.github.com/1712320>.

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

PROMPT="[%n@%m:%F{blue}%~%f] "
RPS1='$(git_prompt_string)'

EDITOR=/usr/local/bin/vim
PAGER=less

path=( /usr/local/sbin           ${path} )
path=( /usr/local/bin            ${path} )
path=( /usr/local/go/bin         ${path} )
path=( /usr/local/vw/bin         ${path} )
path=( ~/bin                     ${path} )

# Java Environment
JAVA_HOME=$(/usr/libexec/java_home)

# Android Environment
export ANDROID_HOME=$HOME/Development/android-adt/sdk
path=( $ANDROID_HOME/tools           ${path} )
path=( $ANDROID_HOME/platform-tools  ${path} )

# GO Environment
GOPATH=$HOME/Development/go
path=( $GOPATH/bin               ${path} )

# Postgres
PGDATA=/usr/local/var/postgres

# Ruby Environment
path=( ${HOME}/.rbenv/bin ${path} )
eval "$(rbenv init -)"

manpath=( /usr/local/man )
manpath=( $manpath /usr/local/share/man )
manpath=( $manpath /usr/share/man )

source ~/.aliases

# map 'up' and 'down' to autocomplete via history
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Backward-kill word, but treat directories in a path as separate words.
# See http://stackoverflow.com/q/444951/46237
bash-style-backward-kill-word () {
  local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
  zle backward-delete-word
}
zle -N bash-style-backward-kill-word
bindkey '^w' bash-style-backward-kill-word

# emacs mode
bindkey -e

[[ -a ~/.liftoff_profile ]] && source ~/.liftoff_profile

# Helper functions for ansible
function ah {
  ansible $1 --list-hosts | head -n 1
}
function ash {
  ssh `ah $1`
}

eval "$(fasd --init auto)"
