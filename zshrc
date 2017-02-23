# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR=/usr/local/bin/vim
export VISUAL=/usr/local/bin/vim
export PAGER=less

[[ -a ~/.liftoff_profile ]] && source ~/.liftoff_profile

path=( /usr/local/sbin           ${path} )
path=( /usr/local/bin            ${path} )
path=( /usr/local/go/bin         ${path} )
path=( /usr/local/vw/bin         ${path} )
path=( ~/bin                     ${path} )

manpath=( /usr/local/man )
manpath=( $manpath /usr/local/share/man )
manpath=( $manpath /usr/share/man )

# GO Environment
export GOPATH=$HOME/dev/go:$LIFTOFF_GOPATH
path=( $HOME/dev/go/bin     ${path} )
path=( $LIFTOFF_GOPATH/bin  ${path} )

# Postgres
export PGDATA=/usr/local/var/postgres

# Ruby Environment
path=( ${HOME}/.rbenv/bin ${path} )
eval "$(rbenv init -)"

# Kafka Environment
export KAFKA_DIR=$HOME/dev/work/kafka

# Java Environment
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

source ~/.aliases

# Helper functions for ansible
# Return the first host in a hosts group
function ah {
  psh -l "=$1" | head -n 1
}

# SSH to the first host listed in a host group
function ash {
  ssh `ah $1`
}

eval "$(fasd --init auto)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
