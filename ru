#!/bin/bash

# ru — Convenience script for SSHing into Rutgers computers

# Usage: ru [NAME] [COMMAND]

# If NAME is '1', '2', '3', or empty, attempts to SSH into ilabNAME.cs.rutgers.edu.
# Otherwise, attempts to SSH into NAME.cs.rutgers.edu.
#     If that fails, attempts to SSH into NAME.rutgers.edu.

# If COMMAND is specified, it is executed on the remote host instead of a login shell.
# If zssh is available, it will be used in place of ssh.

# Examples: `ru 3`, `ru patterns`, `ru nbcs 'cat /etc/hosts'`

USERNAME='CHANGEME'

if [ -x "$(command -v zssh)" ]; then
  printf 'Using zssh for ssh\n\n'
  SSH='zssh'
else
  printf 'zssh unavailable; using ssh\n\n'
  SSH='ssh'
fi

if [[ $1 == '' || $1 =~ ^[1-3]$ ]]; then
  $SSH $USERNAME@ilab$1.cs.rutgers.edu $2
else
  if ping -c 1 $1.cs.rutgers.edu &>/dev/null; then
    $SSH $USERNAME@$1.cs.rutgers.edu $2 2>/dev/null
  elif ping -c 1 $1.rutgers.edu &>/dev/null; then
    $SSH $USERNAME@$1.rutgers.edu $2 2>/dev/null
  else
    printf 'All connections failed\n'
  fi
fi
