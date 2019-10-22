# Bash-persistent-history
Bourne Again Shell persistent history and setting aliases

If not already available in .profile or .bashrc, include there the following:

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

it tests for availability of the script and executes it.
