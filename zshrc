
# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR=/opt/homebrew/bin/vim
export VISUAL=/opt/homebrew/bin/vim
export PAGER=less

source ~/.aliases

eval "$(/opt/homebrew/bin/brew shellenv)"

export PYENV_ROOT="${HOME}/.pyenv"
path=( ${PYENV_ROOT}/bin ${path} )
path=( ${PYENV_ROOT}/shims ${path} )
eval "$(pyenv init -)"

# Don't write .pyc files everywhere.
export PYTHONDONTWRITEBYTECODE=1

fpath=( ${HOME}/dotfiles/zsh-functions ${fpath} )
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  ruby          # Ruby section
  golang        # Go section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  exit_code     # Exit code section
  char          # Prompt character
)
autoload -U promptinit; promptinit
prompt spaceship

# GO Environment
path=( $GOPATH/bin ${path} )
[[ -a ~/.liftoff_profile ]] && source ~/.liftoff_profile

# Ruby Environment
eval "$(rbenv init -)"

path=( ~/bin ${path} )

# Helper functions for ansible
# Return the first host in a hosts group
function ah {
  psh -l "=$1" | head -n 1
}

# SSH to the first host listed in a host group
function ash {
  ssh `ah $1`
}

function apsql {
  psql -h `ah $1` $2 ubuntu
}

function ag2 {
    g2 -addr `psh -l "=$1" | head -n 1`:4388
}

# fasd - fast directory switching
eval "$(fasd --init auto)"

# iterm2 integration
# [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# FZF
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

autoload -U select-word-style
select-word-style bash

HISTSIZE=10000
SAVEHIST=10000
setopt append_history           # allow multiple sessions to append to one history
setopt bang_hist                # treat ! special during command expansion
setopt extended_history         # Write history in :start:elasped;command format
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_space        # prefix command with a space to skip it's recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt inc_append_history       # Write to history file immediately, not when shell quits
setopt share_history            # Share history among all sessions

zstyle ':completion:*:*:git:*' script ~/dotfiles/zsh-functions/git-completion.bash

# # Tab completion
autoload -Uz compinit && compinit
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses
setopt autocd                   # cd to a folder just by typing it's name
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

# Up/Down keys search through history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

zstyle ':completion:*' menu select


# Theme
