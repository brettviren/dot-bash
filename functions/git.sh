
get_git_branch () {
    local branch=$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')
    if [ -z "$branch" ] ; then
	echo "(no branch)"
    fi
    echo "$branch"
}


get_git_commit () {
    commit=$(git describe --dirty 2> /dev/null)
    if [ -z "$commit" ] ; then
	echo "(no commit)"
    fi
    echo $commit
}
