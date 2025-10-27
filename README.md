# Bash Persistent History (BPH)

## 📄 Introduction

**Bash Persistent History (BPH)** is an enhanced Bash script designed to replace and enrich the standard command-line history with essential metadata for auditing and analysis. Unlike the default `.bash_history`, BPH logs every command immediately after execution, including a wealth of contextual information.

The history is stored in a compact, dedicated hidden directory (`$HOME/.phist/`), which improves manageability and prevents cluttering the `$HOME` directory.

### Key Features

* **Rich Metadata:** Each log entry includes: **Date, Time, IP Address, TTY, Exit Status**, and the full command.
* **Structured Logging:** The log is **TAB-separated** (`\t`), making it easy and reliable to parse with tools like `awk` and `cut`.
* **Data-Dump Prevention:** Overly long commands (which are often pasted data dumps or scripts) are detected, truncated, and logged with a **length notification** to preserve log file readability.
* **Dedicated Directory:** All history files are stored under `$HOME/.phist/` for clean organization and easy management.
* **Command Navigation:** The built-in function `h` offers quick access to the full history or the history of the current terminal (TTY).

***

## ⚙️ Installation

To install and activate Bash Persistent History, follow these steps.

### 1. Create the Log Directory

Create the dedicated directory where the history files will be stored.

```bash
mkdir -p $HOME/.phist

2. Configure .bash_aliases

Place the contents of the provided script file (the .bash_aliases code block) into your $HOME/.bash_aliases file.

Note: If you don't have a .bash_aliases file, create it. Ensure your $HOME/.bashrc sources this file (which is standard on most distributions):
Bash

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

3. Activate the Settings

Start a new Bash session or reload your configuration in the current session:
Bash

source ~/.bashrc

Usage

The persistent history is recorded automatically upon command execution. You can view the logs using the function h:
Command	Description
h	Shows the standard Bash history.
h p	Shows the full persistent history ($HOME/.phist/commands.log).
h m	Shows only the persistent history for the current TTY/terminal.

📝 Notes

Log Rotation and Cleanup

Since the history is persistent, the log file $HOME/.phist/commands.log will grow over time. For robust environments, it is highly recommended to configure Logrotate (or a custom cron job) to periodically archive and compress the log file (e.g., to commands-YYYY-MM.log.gz in the same $HOME/.phist/ directory).

Metadata Extraction Example

The log entries are separated by the TAB character (\t). This allows for easy data extraction:
Bash

# Example: Show the count of all unique exit codes (field 5)
cat ~/.phist/commands.log | cut -f 5 | sort | uniq -c

# Example: Search for all commands executed from a specific IP (field 3)
grep -F $'\t'192.168.1.100$'\t' ~/.phist/commands.log
