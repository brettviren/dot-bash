
get_git_branch () {
    local branch=$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')
    if [ -z "$branch" ] ; then
	echo -n "(no branch)"
	return
    fi
    echo -n "$branch"
}


get_git_commit () {
    commit=$(git describe --dirty 2> /dev/null)
    if [ -n "$commit" ] ; then
	echo -n $commit
	return
    fi
    git rev-parse --verify HEAD --short
}
