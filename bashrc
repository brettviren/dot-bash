# -*- shell-script -*-

export TERM=xterm-256color

dot_sourcedir () {
    local dir=$1 ; shift
    if [ ! -d $dir ] ; then
        #echo "dot_sourcedir: given non-directory: $dir"
        return
    fi
    local file
    for file in $dir/*.sh ; do
        if [ -d $file ] ; then continue; fi
        if [ ! -f $file ] ; then continue; fi
        source $file
    done
}

# This file is symlnked to where all the actual bash config files live
DOT_BASH_CONFIG_DIR=$(dirname $(readlink -f $HOME/.bash_login))
dot_sourcedir "$DOT_BASH_CONFIG_DIR/functions"
dot_sourcedir "$DOT_BASH_CONFIG_DIR/variables"
dot_sourcedir "$DOT_BASH_CONFIG_DIR/apps"

if [ -f /etc/bash_completion ] ; then
    source /etc/bash_completion
fi
