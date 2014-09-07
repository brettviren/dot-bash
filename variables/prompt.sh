# set the prompt

# for basics
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# for git, colors and symbols
# https://github.com/twolfson/sexy-bash-prompt/blob/master/.bash_prompt

prompt_command () {
    local last_command_exit=$?

    local Bold="$(tput bold)"
    local Reset="$(tput sgr0)"

    local GitColor="$(tput setaf 154)"
    local PathColor="$(tput setaf 33)"

    local RootColor="$(tput setaf 9)"
    local UserColor="$(tput setaf 54)"

    local RCColor="$Reset"
    local SuccColor="$(tput setaf 76)"
    local FailColor="$(tput setaf 9)"
    local FancyX='\342\234\227'
    local Checkmark='\342\234\223'

    # to three line prompt, let path be as long as it wanna be
    unset PROMPT_DIRTRIM
    PS1="\n"

    # last command exit code
    PS1+="$RCColor\$(printf "%03d" $last_command_exit) "
    if [[ $last_command_exit == 0 ]]; then
        PS1+="$SuccColor$Checkmark"
    else
        PS1+="$FailColor$FancyX"
    fi
    PS1+="$Reset"
    
    # who we are and were we at
    if [[ $EUID == 0 ]]; then
        PS1+=" $RootColor\h $PathColor\w"
    else
        PS1+=" $UserColor\u@\h $PathColor\w"
    fi

    if git rev-parse > /dev/null 2>&1 ; then
	# Insert git stuff
	local branch=$(get_git_branch)
	local commit=$(get_git_commit)
	PS1+=" $Reset[$GitColor$branch:$commit$Reset]"
    fi

    # last bit, start new line, no funky stuff after that to avoid
    # confusing readline editing

    PS1+="$Reset\n\\\$ "

}

export PROMPT_COMMAND='prompt_command'
