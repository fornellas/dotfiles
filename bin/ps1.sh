function ansi_display_sequence_ps1() {
  echo -n "\[$(ansi_display_sequence "$@")\]"
}

# Exit status
PS1_STATUS="\$(
  RET=\$?
  if [ \$RET -eq 0 ]
  then
    echo -ne '$(
      ansi_display_sequence_ps1 \
        $ANSI_DISPLAY_ATTR_BRIGHT \
        $ANSI_DISPLAY_FG_GREEN
      )✔'
  else
    echo -ne '$(
    ansi_display_sequence_ps1 \
    $ANSI_DISPLAY_ATTR_BRIGHT \
    $ANSI_DISPLAY_FG_RED
    )✘'
  fi
  )"

# User
if [ $UID -eq 0 ]
then
  PS1_USER_COLOR="$ANSI_DISPLAY_FG_RED"
else
  PS1_USER_COLOR="$ANSI_DISPLAY_FG_GREEN"
fi
PS1_USER="$(ansi_display_sequence_ps1 $PS1_USER_COLOR)\\u"

# @
PS1_AT="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE)@"

# Hostname
PS1_HOSTNAME_ATTR="DIM"
PS1_HOSTNAME_FG="CYAN"
PS1_HOSTNAME_BG=""
PS1_HOSTNAME="$(eval "ansi_display_sequence_ps1 \
  \$ANSI_DISPLAYATTR_$PS1_HOSTNAME_ATTR \
  \$ANSI_DISPLAY_FG_$PS1_HOSTNAME_FG \
  \$ANSI_DISPLAY_BG_$PS1_HOSTNAME_BG
  ")\\h"

# :
PS1_COLON="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE):"

# PWD
PS1_PWD="$(ansi_display_sequence_ps1)\\w"

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
  PS1_GIT="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE)\$(__git_ps1)"
else
  PS1_GIT=""
fi

# $/#
PS1_END="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE)\\\$"

# Set PS1
PS1="${PS1_STATUS}${PS1_USER}${PS1_AT}${PS1_HOSTNAME}${PS1_COLON}${PS1_PWD}${PS1_GIT}${PS1_END}$(ansi_display_sequence_ps1) "
