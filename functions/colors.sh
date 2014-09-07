# http://linuxtidbits.wordpress.com/2008/08/11/output-color-on-bash-scripts/

color_table () {

    echo
    echo -e "$(tput bold) reg  bld  und   tput-command-colors$(tput sgr0)"

    for i in {1..7}; do
	echo " $(tput setaf $i)Text$(tput sgr0) $(tput bold)$(tput setaf $i)Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Text$(tput sgr0)  \$(tput setaf $i)"
    done

    echo ' Bold            $(tput bold)'
    echo ' Underline       $(tput sgr 0 1)'
    echo ' Reset           $(tput sgr0)'

}

# http://www.commandlinefu.com/commands/view/6533/print-all-256-colors-for-testing-term-or-for-a-quick-reference
color_table_16 () {
( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;for i in {0..16};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done; )
}
color_table_256 () {
    local x=`tput op` 
    local y=`printf %$((${COLUMNS}-6))s`
    for colnum in {0..15} ; do
	for rownum in {0..15} ; do
	    color=$(( $colnum * 16 + $rownum))
	    tput setaf $color
	    printf '%03d ' $color
	done
	echo
    done
	#echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done; )
}
