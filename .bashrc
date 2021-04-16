# eventually, From Bash Cookbook
# cookbook filename: func_pathmunge
# Adapted from Red Hat Linux
listmunge() {
    lname=$1
    new_elem=$2
    after_p=$3
    local foo
    foo=${!lname}

    if ! echo ${!lname} | grep -E -q "(^|:)$new_elem($|:)" ; then
        if [[ $after_p = after ]] ; then
            foo="${!lname}:$new_elem"
        else
            foo="${new_elem}:${!lname}"
        fi
    fi

    # In case lname was empty to begin with, trim orphan ':' as appropriate
    blarf="`echo "$foo" | sed -e 's/^://' -e 's/:$//' -e 's/ /\\ /g'`"
    eval "$lname=\"$blarf\""
}


listmunge PATH $HOME/bin
listmunge PATH $HOME/local/bin

#export MANPATH
#listmunge MANPATH $HOME/local/man
#listmunge MANPATH $HOME/local/share/man
#listmunge MANPATH /usr/share/man

# Check for an interactive session
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... and ignore same sucessive entries.
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
shopt -s histappend                      # append to history, don't overwrite it

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

PS1='[\u@\h \W]\$ '

DEBEMAIL=rforgey@grumpydogconsulting.com
DEBFULLNAME="Bob Forgey"
export DEBEMAIL DEBFULLNAME

export TERM=vt100

Files()
{
    diff -w "$1" "$3"
}

Only()
{
# i.e.: Only in ../../org-jekyll/css: main.scss
    cp -i "${3%%:}/$4" ./
}

# Per system-type configs
sys=`uname -o`
test -f ~/.bash.d/$sys &&  . ~/.bash.d/$sys

# Per-location configs
junk=${SSMM_LOC:?}              # Make sure it's defined (from .bash_profile)
test -f ~/.bash.d/$SSMM_LOC &&  . ~/.bash.d/$SSMM_LOC

# Per-machine configs
name=`uname -n`
test -f ~/.bash.d/$name &&  . ~/.bash.d/$name

#listmunge PATH $HOME/.local/bin after

vterm_printf(){
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
