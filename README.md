# Bash-persistent-history

Bourne Again Shell persistent history and setting aliases

This tiny script prepends date, time, IP-address, tty and exit status for each command.
When working simultaneously with another user, you can filter on current tty (option m).
The resulting history will be written in plain text to $HOME/.persistent_history

If not already available in .profile or .bashrc, include there the following:

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

This tests for availability of the script and executes it.

# Usage:

h <option>, where option is:
    m my personal persistant history (current tty)
    p sorted persistent history

If no option is given, the standard Bash history will be shown.
