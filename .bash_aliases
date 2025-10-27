# === BASH PERSISTENT HISTORY (V3.1: Met Zoekfunctie) ===
#
# GitHub: [INSERT YOUR GITHUB LINK HERE]
#
# Stop if this is not a Bash shell
if [ `basename $SHELL` != "bash" ]; then exit; fi

# Adjust PATH
PATH=$HOME/bin:/local/bin:$PATH

# --- LOG SETTINGS ---
# The logs will reside in a dedicated hidden directory:
readonly PH_LOG_DIR="$HOME/.phist"
# The main log file:
readonly PH_COMMAND_LOG="$PH_LOG_DIR/commands.log"
# Field separator (TAB-separated)
readonly PH_SEPARATOR=$'\t'
# Maximum length for a command; above this is considered a data-dump/paste
readonly MAX_CMD_LENGTH=2048

# Set the time format for the standard Bash history (essential for persistent_history)
HISTTIMEFORMAT='%F %T '

# Functie om de persistente geschiedenis te bekijken
h ()
{
    # Check if the log file exists
    if [ ! -f "$PH_COMMAND_LOG" ]; then
        echo "Persistent history logfile not found at: $PH_COMMAND_LOG"
        history
        return 0
    fi

    case $1 in
        "")
            history
            ;;
        m)
            # Toon geschiedenis alleen voor de huidige TTY.
            TTY=`tty|sed -e "s/\/dev\///"`; cat "$PH_COMMAND_LOG" | grep "$PH_SEPARATOR$TTY$PH_SEPARATOR"
            ;;
        p)
            # Toon de volledige persistente geschiedenis
            cat "$PH_COMMAND_LOG"
            ;;
        s)
            if [ -z "$2" ]; then
                echo "Fout: Geef een zoekterm op voor de zoekfunctie (h s <term>)."
                return 1
            fi
            # Zoek hoofdletterongevoelig (grep -i) in het volledige logbestand
            echo "--- Resultaten voor '$2' in $PH_COMMAND_LOG: ---"
            grep -i "$2" "$PH_COMMAND_LOG"
            ;;
        *)
            cat <<_EOF
Usage: h <option>, where option is:
<none>   standard Bash history
m        my personal persistent history (current TTY)
p        full persistent history
s <term> search the full persistent history (case-insensitive)
_EOF
            ;;
    esac
}

### PERSISTENT HISTORY MAIN FUNCTION
PROMPT_COMMAND="persistent_history"
persistent_history ()
{
    local PHexit=$?
    local PHuser PHtty PHhost PHdate PHtime PHcmd PHcmd_len

    # Ensure the log directory exists
    mkdir -p "$PH_LOG_DIR" 2>/dev/null

    # 1. Determine User, TTY, and Host
    read PHuser PHtty PHhost <<< $(who am i 2>/dev/null | tr -d "[()]" | awk '{ print $1,$2,$NF }')

    # Fallbacks
    if [ -z "$PHuser" ]; then PHuser=`id -nu`; fi
    if [ -z "$PHtty" ]; then PHtty=`tty|sed -e 's/\/dev\///'`; fi
    # Use hostname -I for local IP (more reliable than -i)
    if [ -z "$PHhost" ]; then PHhost=`hostname -I 2>/dev/null | awk '{print $1}'`; fi
    if [ -z "$PHhost" ]; then PHhost="UNKNOWN_IP"; fi

    # 2. Get Command and Timestamp from Bash history
    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    PHdate_time="${BASH_REMATCH[1]}"
    PHcmd="${BASH_REMATCH[2]}"

    # Split the date and time
    read PHdate PHtime <<< $(echo $PHdate_time)

    # 3. Prevent command repetition and log
    if [ -n "$PHcmd" ] && [ "$PHcmd" != "$PERSISTENT_HISTORY_LAST" ]
    then
        PHcmd_len=${#PHcmd}

        if [ "$PHcmd_len" -gt "$MAX_CMD_LENGTH" ]; then
            # Command is too long (likely data-dump/paste). Log the length and a snippet.
            PHcmd="[DATA DUMP/PASTE - LENGTH: $PHcmd_len bytes] $(echo "$PHcmd" | head -c 100)..."
        fi

        # Log format: Date \t Time \t Host \t TTY \t ExitStatus \t Command
        echo -e "$PHdate$PH_SEPARATOR$PHtime$PH_SEPARATOR$PHhost$PH_SEPARATOR$PHtty$PH_SEPARATOR$PHexit$PH_SEPARATOR$PHcmd" >> "$PH_COMMAND_LOG"
        export PERSISTENT_HISTORY_LAST="$PHcmd"
    fi
}

# === ALIASES ===
alias l='ls -alF --group-directories-first'
alias ..='cd ..'
# Activate the mc alias to ensure TUI mode, even in a graphical terminal
alias mc='unset DISPLAY; source /usr/lib/mc/mc-wrapper.sh'
