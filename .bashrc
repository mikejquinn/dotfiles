export PS1="\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
export DISPLAY=:0.0
export EDITOR=/usr/bin/vim

# Configure Java paths
export JAVA_HOME=/Library/Java/Home
export PATH=$JAVA_HOME/bin:$PATH

# Configure Ant
export ANT_HOME=/usr/share/ant
export PATH=$ANT_HOME/bin:$PATH

export PATH=$HOME/bin:$PATH

source ~/.aliases

if [ -d /opt/android ]; then
  export ANDROID_HOME=/opt/android
  export PATH=$PATH:$ANDROID_HOME/tools
fi

function cdgem() {
  GEMPATH=`gem which $1`
  pushd .
  cd `dirname $GEMPATH`
}

# So that 'up' and 'down' will autocomplete via history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
