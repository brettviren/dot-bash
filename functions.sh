# source this to define all files in 
# $DOT_BASH_CONFIG_DIR/functions/

# Source all .sh files in a given directory
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

dot_sourcedir "$(dirname $(readlink -f $BASH_SOURCE))/functions"
