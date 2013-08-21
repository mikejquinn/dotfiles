#!/bin/zsh

umask  022

setopt NO_BG_NICE
setopt COMPLETE_IN_WORD
setopt NOBGNICE
setopt ALL_EXPORT
setopt GLOB_DOTS
setopt prompt_subst

limit coredumpsize unlimited

. ~/bin/z.sh
#. ~/.liftoff_profile

# setup history
setopt EXTENDED_HISTORY
#setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_SAVE_NO_DUPS
HISTFILE=~/.history
SAVEHIST=10000
alias history 'history -l ${HISTSIZE}'


PROMPT="[%n@%m:%F{blue}%~%f] "
RPROMPT='[%F{blue}%W %T%f]'

SHELLCONFIG=${HOME}/Development/env/shellconfig/
EDITOR=/usr/bin/vim
PAGER=less

JAVA_HOME=$(/usr/libexec/java_home)
#JAVA_HOME_7=/System/Library/Java/JavaVirtualMachines/1.7.0_10.jdk/Contents/Home
ANDROID_HOME=/opt/android
CELLBLOCK_HOME=~/dev/java/cellblock
ANT_HOME=~/Development/java/cellblock/tools/ant/apache-ant-1.6.5
NODE_PATH=/usr/local/lib/node_modules

# Amazon Web Services paths
AWS_HOME=~/Development/amazon-aws
AWS_ELASTICACHE_HOME=${AWS_HOME}/AmazonElastiCacheCli-1.6.001
EC2_HOME=${AWS_HOME}/ec2-api-tools-1.6.6.4
AWS_AUTO_SCALING_HOME=${AWS_HOME}/AutoScaling-1.0.61.2

# Postgres
PGDATA=/usr/local/var/postgres

# Set up my path
path=( ${HOME}/.rbenv/bin ${path} )
eval "$(rbenv init -)"

path=( /usr/local/bin            ${path} )
path=( /usr/local/sbin           ${path} )
path=( ${CELLBLOCK_HOME}/tools/mplayer/linux ${path} )
path=( ${ANT_HOME}/bin           ${path} )
path=( ${JAVA_HOME}/bin          ${path} )
path=( ${ANDROID_HOME}/tools     ${path} )
path=( ${AWS_ELASTICACHE_HOME}/bin     ${path} )
path=( ${EC2_HOME}/bin           ${path} )
path=( ${AWS_AUTO_SCALING_HOME}/bin    ${path} )
path=( /Users/mquinn/bin         ${path} )
path=( /Users/mquinn/bin/mongodb ${path} )
path=( /opt/app_engine           ${path} )
path=( /opt/restdown/bin         ${path} )

# Maven 2.2.1
#MAVEN2_HOME=/usr/share/java/maven-2.2.1
#path=( ${MAVEN2_HOME}/bin        ${path} )
#M2_HOME=${MAVEN2_HOME}
#M2=${M2_HOME}/bin

# Set my environmental variables
typeset -T LD_LIBRARY_PATH ld_library_path

typeset -T CLASSPATH classpath
#classpath=()

typeset -T TAGSPATH tagspath , # vim expects TAGSPATH to be comma-separated
#tagspath=()

# typeset -T CDPATH cdpath # done by default
# CDPATH cdpath
cdpath=( . )
cdpath=( $cdpath ${HOME} )
cdpath=( $cdpath ${HOME}/dev/iphone/ )
cdpath=( $cdpath ${HOME}/dev/ruby/ )
cdpath=( $cdpath ${HOME}/Desktop/ )

# typeset -T FPATH fpath # done by default
# FPATH fpath
fpath=( $fpath ${SHELLCONFIG}/functions/ )

#typeset -T MANPATH manpath # done by default
#manpath=( /usr/local/man )
#manpath=( $manpath /usr/share/man )
#manpath=( $manpath /usr/X11R6/man )

# it's really a shame that these don't seem to work within Mac's Terminal program...
# they're really useful for resizing terminals at the command line.
#alias wt='st 80 40'
#function st() { echo  "\033[8;$2;$1t" }

# make it easier to go back and forth between machines
alias db2='ssh db2'
alias web4='ssh web4'
alias web5='ssh web5'

for function_file ( ` find ${SHELLCONFIG}/functions/ -type f` )
do
  function_name=$( basename $function_file )
  autoload $function_name
  #source $function_file
done

source ~/.aliases

# map 'up' and 'down' to autocomplete via history
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# emacs mode
bindkey -e
