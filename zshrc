#!/bin/zsh

umask  022

# emacs mode
bindkey -e

setopt NO_BG_NICE       # Don't run background jobs at a lower priority
setopt GLOB_DOTS        # Don't require a leading '.' in a filename to be matched

limit coredumpsize unlimited

### General configuration -----------------------------------------------------------------------------------

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
alias h='fc -f -l 100'

# Filename generation options
setopt EXTENDED_GLOB # Extended glob patterns
setopt NO_MATCH      # Raise an error if a filename pattern has no matches
unsetopt CASE_GLOB   # Make globbing case-insensitive

export CLICOLOR=1    # Show colors in ls output

# Directory switching
setopt AUTO_PUSHD        # Push each directory onto the stack
setopt PUSHD_IGNORE_DUPS # Don't push duplicate entries onto the stack

# zmv for easy batch file renaming (http://zshwiki.org/home/builtin/functions/zmv)
autoload -U zmv

# Misc
setopt NOTIFY # Immediately report status of background jobs
unsetopt BEEP # Don't beep on zle errors

REPORTTIME=30 # Report CPU stats on operations taking more than 30 seconds.

# Map 'up' and 'down' to autocomplete via history
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

### Set up my prompt ----------------------------------------------------------------------------------------
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

### Autocomplete --------------------------------------------------------------------------------------------

zstyle :compinstall filename '/Users/mikeq/.zshrc'
autoload -Uz compinit
compinit -i

unsetopt MENU_COMPLETE
unsetopt FLOW_CONTROL
setopt COMPLETE_IN_WORD # Keep cursor in its place when completion is started
setopt AUTO_MENU
setopt ALWAYS_TO_END

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' prompt '%e possible corrections'
zstyle ':completion:*' verbose true
# Color for 'kill'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Caching for completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh_cache/
# Ignore completion functions for non-existent commands
zstyle ':completion:*:functions' ignored-patterns '_*'
# Prevent cd from selecting the parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

fpath=(~/.rbenv/versions/2.0.0-p598/lib/ruby/gems/2.0.0/gems/timetrap-1.8.14/completions/zsh/ $fpath)

### System configuration ------------------------------------------------------------------------------------

export EDITOR=/usr/local/bin/vim
export VISUAL=/usr/local/bin/vim
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
PAGER=less

path=( /usr/local/sbin           ${path} )
path=( /usr/local/bin            ${path} )
path=( /usr/local/go/bin         ${path} )
path=( /usr/local/vw/bin         ${path} )
path=( ~/bin                     ${path} )

# Java Environment
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home"

# Android Environment
export ANDROID_HOME=$HOME/Library/Android/sdk
path=( $ANDROID_HOME/tools           ${path} )
path=( $ANDROID_HOME/platform-tools  ${path} )

# GO Environment
export LIFTOFF_GOPATH=$HOME/dev/go-liftoff
export GOPATH=$HOME/dev/go:$LIFTOFF_GOPATH
path=( $HOME/dev/go/bin      ${path} )

# Postgres
export PGDATA=/usr/local/var/postgres

# Ruby Environment
path=( ${HOME}/.rbenv/bin ${path} )
eval "$(rbenv init -)"

# Kafka Environment
export KAFKA_DIR=$HOME/dev/work/kafka

# Node Environment
export NODE_PATH="/usr/local/lib/node_modules"

manpath=( /usr/local/man )
manpath=( $manpath /usr/local/share/man )
manpath=( $manpath /usr/share/man )

source ~/.aliases

[[ -a ~/.liftoff_profile ]] && source ~/.liftoff_profile

# Helper functions for ansible
# Return the first host in a hosts group
function ah {
  ansible $1 --list-hosts | head -n 1
}

# SSH to the first host listed in a host group
function ash {
  ssh `ah $1`
}

eval "$(fasd --init auto)"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
