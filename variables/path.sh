# export PATh related variables

for maybe in $HOME/.local/bin $HOME/share $HOME/scripts $HOME/bin
do
    if [ -d $maybe ] ; then
	path_prepend $maybe
    fi
done

