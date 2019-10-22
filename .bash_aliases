# Personal BASH adaptions

if [ `basename $SHELL` != "bash" ]; then exit; fi

PATH=$HOME/bin:/local/bin:$PATH

HISTTIMEFORMAT='%F %T '

_history ()
{
    case $1 in
        "")
            history
            ;;
        m)
            TTY=`tty|sed -e "s/\/dev\///"`; sort ~/.persistent_history | grep $TTY
            ;;
        p)
            sort ~/.persistent_history
            ;;
        *)
            cat <<_EOF
Usage: h <option>, where option is:
h standard Bash history
m my personal persistant history
p full persistant history
_EOF
            ;;
    esac
}

### PERSISTENT HISTORY
PROMPT_COMMAND="persistent_history"
persistent_history ()
{
    local PHexit=$?

    local PHuser PHtty PHhost
    read  PHuser PHtty PHhost <<< $(who am i | tr -d "[()]" | awk '{ print $1,$2,$NF }')

    if [ -z $PHuser ]; then PHuser=`id -nu`; fi
    if [ -z $PHtty  ]; then PHtty=`tty|sed -e 's/\/dev\///'`; fi
    if [ -z $PHhost ]; then PHhost=`hostname -i`; fi

    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    local PHdate="${BASH_REMATCH[1]}"
    local PHcmd="${BASH_REMATCH[2]}"

# Suppress recurring comands in persistent history
    if [ "$PHcmd" != "$PERSISTENT_HISTORY_LAST" ]
    then
        echo $PHdate $PHhost $PHtty $PHexit "|" "$PHcmd" >> ~/.persistent_history
        export PERSISTENT_HISTORY_LAST="$PHcmd"
    fi
}

alias h="_history $@"
alias l='ls -alF --group-directories-first'
alias ..='cd ..'
