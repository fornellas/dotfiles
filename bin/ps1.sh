function ansi_set_attr_ps1() {
  echo -n "\[$(ansi_set_attr RESET "$@")\]"
}

# Exit status
PS1_STATUS="\$(
  RET=\$?
  if [ \$RET -eq 0 ]
  then
    echo -ne '$(ansi_set_attr_ps1 BRIGHT FG_GREEN)✔'
  else
    echo -ne '$(ansi_set_attr_ps1 BRIGHT FG_RED)✘'
  fi
)"

# User
if [ $UID -eq 0 ]
then
  PS1_USER_COLOR="FG_RED"
else
  PS1_USER_COLOR="FG_GREEN"
fi
PS1_USER="$(ansi_set_attr_ps1 $PS1_USER_COLOR)\\u"

# @
PS1_AT="$(ansi_set_attr_ps1 BRIGHT FG_WHITE)@"

# Hostname
PS1_HOSTNAME="$(ansi_set_attr_ps1 FG_CYAN)\\h"

# :
PS1_COLON="$(ansi_set_attr_ps1 BRIGHT FG_WHITE):"

# PWD
PS1_PWD="$(ansi_set_attr_ps1)\\w"

# Git status
GIT_SH_PROMPT="/usr/lib/git-core/git-sh-prompt"
if [ -f "$GIT_SH_PROMPT" ] ; then
  source /usr/lib/git-core/git-sh-prompt
fi
if type __git_ps1 &>/dev/null ; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_SHOWCOLORHINTS=true
  PS1_GIT="$(ansi_set_attr_ps1 BRIGHT FG_WHITE)\$(__git_ps1)"
else
  PS1_GIT=""
fi

# $/#
PS1_END="$(ansi_set_attr_ps1 BRIGHT FG_WHITE)\\\$"

# Set PS1
PS1="${PS1_STATUS}${PS1_USER}${PS1_AT}${PS1_HOSTNAME}${PS1_COLON}${PS1_PWD}${PS1_GIT}${PS1_END}$(ansi_set_attr_ps1 RESET) "
