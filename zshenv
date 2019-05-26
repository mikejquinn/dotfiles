#!/bin/zsh

# Zsh will source /etc/zprofile in login shells, which blows
# away the PATH.
setopt no_global_rcs

path=()

path=(
  ~/bin
  /sbin
  /usr/sbin
  /usr/local/sbin
  /bin
  /usr/bin
  /usr/local/bin
)

# GO Environment
export GOPATH="$HOME/dev/go"
path=( $GOPATH/bin ${path} )
[[ -a ~/.liftoff_profile ]] && source ~/.liftoff_profile

# Paths to some older versions of homebrew packages.
path=( /usr/local/opt/python@2/bin      ${path} )
path=( /usr/local/opt/node@10/bin       ${path} )
path=( /usr/local/opt/postgresql@10/bin ${path} )

manpath=( /usr/local/man )
manpath=( $manpath /usr/local/share/man )
manpath=( $manpath /usr/share/man )

# Postgres
export PGDATA=/usr/local/var/postgres

# Kafka Environment
export KAFKA_DIR=$HOME/dev/work/kafka

# Java Environment
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# Node Environment
export NODE_PATH="/usr/local/lib/node_modules"

# Rust Environment
# ~/.cargo/bin
# export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Ruby Environment
path=( ${HOME}/.rbenv/bin ${path} )
eval "$(rbenv init -)"
