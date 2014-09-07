# set the prompt

# for basics
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# for git, colors and symbols
# https://github.com/twolfson/sexy-bash-prompt/blob/master/.bash_prompt

export TERM=xterm-256color

prompt_command () {
    local last_command_exit=$?

    local Bold="$(tput bold)"
    local Reset="$(tput sgr0)"

    local Blue="$(tput setaf 27)"
    local White="$(tput setaf 7)"
    local Cyan="$(tput setaf 39)"
    local Green="$(tput setaf 76)"
    local Yellow="$(tput setaf 154)"
    local Red="$(tput setaf 9)"

    local FancyX='\342\234\227'
    local Checkmark='\342\234\223'

    # to three line prompt, let path be as long as it wanna be
    unset PROMPT_DIRTRIM
    PS1="\n"

    # last command exit code
    PS1+="$Bold$White\$? "
    if [[ $last_command_exit == 0 ]]; then
        PS1+="$Green$Checkmark "
    else
        PS1+="$Red$FancyX "
    fi
    PS1+="$Reset"
    
    # Insert git stuff
    GIT_PS1_DESCRIBE_STYLE=describe
    PS1+="$Blue$(__git_ps1 '(%s)')$Reset "

    # who we are and were we at
    if [[ $EUID == 0 ]]; then
        PS1+="$Red\h $Blue\w\n$Red\\\$"
    else
        PS1+="$Green\u@\h $Blue\w\n$White\\\$"
    fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Reset "

}

export PROMPT_COMMAND='prompt_command'
