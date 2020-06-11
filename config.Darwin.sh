#!/bin/bash

CURRDIR=`pwd`

if [[ "$TERM_PROGRAM" == "iTerm.app" ]] ; then
  printf "\n> You appear to be running this script from within iTerm.app which could\n"
  printf "  overwrite your new preferences on quit.\n"
  printf "> Please quit iTerm and run this from Terminal.app or an SSH session.\n"
  printf "  Cheers.\n\n"
  exit 3
fi

if ps wwwaux | egrep -q 'iTerm\.app' >/dev/null ; then
  printf "\n> You appear to have iTerm.app currently running. Please quit the\n"
  printf "  application so your updates won't get overridden on quit.\n\n"
  exit 4
fi

SCRIPTDIR=$(cd `dirname $0` && pwd)

# Create Links
cd ~
ln -sf $SCRIPTDIR/aliases .aliases
ln -sf $SCRIPTDIR/zshenv .zshenv
ln -sf $SCRIPTDIR/zshrc .zshrc
ln -sf $SCRIPTDIR/tigrc .tigrc
ln -sf $SCRIPTDIR/psqlrc .psqlrc
ln -sf $SCRIPTDIR/ssh-config .ssh/config
ln -sf $SCRIPTDIR/agignore .agignore

ln -sf $SCRIPTDIR/gitconfig .gitconfig
ln -sf $SCRIPTDIR/gitignore_global .gitignore_global
ln -sf $SCRIPTDIR/vim-config .vim
ln -sf $SCRIPTDIR/hammerspoon .hammerspoon

# Install Homebrew
if [[ ! -e "/usr/local/Cellar" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
if [[ ! -e "/usr/local/Homebrew/Library/Taps/railwaycat/homebrew-emacsmacport" ]]; then
  brew tap railwaycat/emacsmacport
fi

brew update
brew install \
  autoconf \
  automake \
  fasd \
  fzf \
  gdbm \
  go \
  emacs-mac \
  jq \
  imagemagick \
  leiningen \
  maven \
  openssl \
  ossp-uuid \
  parallel \
  pcre \
  pkg-config \
  postgresql \
  rbenv \
  readline \
  redis \
  ruby-build \
  the_silver_searcher \
  tig \
  vim \
  wget \
  xz \
  zsh \
  zsh-completions

# Speed up keyboard repeat
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
