# set the prompt

# for basics
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# for git, colors and symbols
# https://github.com/twolfson/sexy-bash-prompt/blob/master/.bash_prompt

# to get lengths right make sure control chars are in "\\[...\\]" or
# '\[...\]"
# http://askubuntu.com/questions/24358/how-do-i-get-long-command-lines-to-wrap-to-the-next-line
# that's just so readline does freak out.  If one wants to directly
# calculate lengths, for example to mke right-justified lines, you
# gotta explicitly not count them.

function timer_start {
  timer=${timer:-$SECONDS}
}
trap 'timer_start' DEBUG

prompt_command () {
    local last_command_exit=$?

    # general
    local Bold="\\[$(tput bold)\\]"
    local Reset="\\[$(tput sgr0)\\]"

    # return code reporting
    local RCColor="$Reset"
    local FailColor="\\[$(tput setaf 9)\\]"
    local FailChar='\342\234\227'
    local OkayColor="\\[$(tput setaf 76)\\]"
    local OkayChar='\342\234\223'

    local rc="$(printf '%03d' $last_command_exit)$FailChar"
    local rc_color="${FailColor}${rc}${Reset}"
    if [[ $last_command_exit == 0 ]]; then
	rc="$(printf '%03d' $last_command_exit)$OkayChar"
	rc_color="${OkayColor}${rc}${Reset}"
    fi


    # who and where am I
    local PathColor="\\[$(tput setaf 33)\\]"
    local RootColor="\\[$(tput setaf 9)\\]"
    local UserColor="\\[$(tput setaf 129)\\]"

    local hostname="$(hostname)"
    local ww="${USER}@${hostname}:$(pwd)"
    local ww_color="${UserColor}${USER}@${hostname}${Reset}:${PathColor}$(pwd)${Reset}"
    if [[ $EUID == 0 ]]; then
	local ww="ROOT@${hostname}:$(pwd)"
	local ww_color="${RootColor}ROOT@${hostname}${Reset}:${PathColor}$(pwd)${Reset}"
    fi


    # Application specific

    # Virtual Environment
    local VenvColor="\\[$(tput setaf 213)\\]"
    
    local venv=""
    local venv_color=""
    if [ -n "$VIRTUAL_ENV" ] ; then
	venv="[$(basename $VIRTUAL_ENV)]"
	venv_color="${VenvColor}${venv}${Reset}"
    fi

    # Insert git stuff if we are in a git dir
    local GitColor="\\[$(tput setaf 154)\\]"
    local gits=""
    local gits_color=""
    if git rev-parse > /dev/null 2>&1 ; then
	local branch=$(get_git_branch)
	local commit=$(get_git_commit)
	gits="[${branch}:${commit}]"
	gits_color="${GitColor}${gits}${Reset}"
    fi

    # timer
    local DashColor="\\[$(tput setaf 240)\\]"
    timer_show=$(($SECONDS - $timer))
    unset timer
    tt=""
    tt_color="${DashColor}"
    if [[ $timer_show > 0 ]] ; then
	tt="[${timer_show}s] "
	tt_color+="$tt" # no reset
    fi

    # now put it together
    shell_prompt='\n'

    fudge=10			# from the OkayChar/FailChar
    ndashes=$(( $(tput cols) - $(echo "${rc}${tt}" | wc -c) + $fudge ))
    dashes=$(printf "\\u2500%.0s" $(seq $ndashes))
    shell_prompt+="${rc_color} ${tt_color}${dashes}\n"

    plain_text="${ww}${venv}${gits}"
    ngap=$(( $(tput cols) - $(echo "$plain_text" | wc -c) ))
    gap="$(printf %${ngap}s)"

    
    shell_prompt+="${ww_color}${gap}${venv_color}${gits_color}\n\\$ "

    PS1="${shell_prompt}"

    # set xterm title
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
}



simple_prompt_command () {
    local BOLD="\\[$(tput bold)\\]"
    local RESET="\\[$(tput sgr0)\\]"
    local RED="\\[$(tput setaf 9)\\]"
    local BLUE="\\[$(tput setaf 33)\\]"

    lhs=${USER}@${HOST}:$(pwd)
    lhs_col="${BOLD}${RED}$lhs${RESET}"
    rhs="$(date)"
    rhs_col="${BLUE}${rhs}${RESET}"
    ngap=$(( $(tput cols) - $(echo "$lhs$rhs" | wc -c) ))
    gap=""
    if [[ $ngap -gt 0 ]] ; then
	gap="$(printf '%'$ngap's')"
    fi
    PS1="${lhs_col}${gap}${rhs_col}\n\\$ "

    date > $HOME/prompt.log
    cat <<EOF >> $HOME/prompt.log
ngap: $ngap
 lhs: $lhs
 rhs: $rhs
EOF

}

export PROMPT_COMMAND='prompt_command'
