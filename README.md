# Bash-persistent-history

Bourne Again Shell persistent history and setting aliases

This tiny script prepends date, time, IP-address, tty and exit status for each command.

When working simultaneously with another user, you can filter on current tty (option m).

The resulting history will be written in plain text to $HOME/.persistent_history

# Installation:<br>

Place .bash_aliases in your home-directory.

If not already available in .profile or .bashrc, include there the following:

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

This tests for availability of the script and executes it.

At a new login, the functionalities will be automatically available.

# Usage:<br>

h [option], where option is:<br><br>
m persistent history for current tty<br>
p sorted persistent history

If no option is given, the standard Bash history will be shown.

Persistent history means that it keeps growing, so be aware of ending up with a big file.
Therefor keep an eye on the history file and weed out irrelevant information with an editor.
Editing the persistent history file doesn't affect the working of the script.
