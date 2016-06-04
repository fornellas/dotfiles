# http://www.termsys.demon.co.uk/vtansi.htm

# Escape
ANSI_ESCAPE="\\033"

# Display Attributes
ANSI_DISPLAY_ATTR_RESET="0"
ANSI_DISPLAY_ATTR_BRIGHT="1"
ANSI_DISPLAY_ATTR_DIM="2"
ANSI_DISPLAY_ATTR_UNDERSCORE="4"
ANSI_DISPLAY_ATTR_BLINK="5"
ANSI_DISPLAY_ATTR_REVERSE="7"
ANSI_DISPLAY_ATTR_HIDDEN="8"
ANSI_DISPLAY_ATTR_FG_BLACK="30"
ANSI_DISPLAY_ATTR_FG_RED="31"
ANSI_DISPLAY_ATTR_FG_GREEN="32"
ANSI_DISPLAY_ATTR_FG_YELLOW="33"
ANSI_DISPLAY_ATTR_FG_BLUE="34"
ANSI_DISPLAY_ATTR_FG_MAGENTA="35"
ANSI_DISPLAY_ATTR_FG_CYAN="36"
ANSI_DISPLAY_ATTR_FG_WHITE="37"
ANSI_DISPLAY_ATTR_BG_BLACK="40"
ANSI_DISPLAY_ATTR_BG_RED="41"
ANSI_DISPLAY_ATTR_BG_GREEN="42"
ANSI_DISPLAY_ATTR_BG_YELLOW="43"
ANSI_DISPLAY_ATTR_BG_BLUE="44"
ANSI_DISPLAY_ATTR_BG_MAGENTA="45"
ANSI_DISPLAY_ATTR_BG_CYAN="46"
ANSI_DISPLAY_ATTR_BG_WHITE="47"

function ansi_set_attr() {
  ATTRIBUTES=""
  while [ $# -ge 1 ]
  do
    ATTRIBUTES="${ATTRIBUTES}$(eval "echo -n \$ANSI_DISPLAY_ATTR_$1")"
    if [ $# -gt 1 ]
    then
      ATTRIBUTES="${ATTRIBUTES};"
    fi
    shift
  done
  echo -en "$ANSI_ESCAPE[${ATTRIBUTES}m"
}


function ansi_sample_all() {
  for ATTR in NONE BRIGHT DIM UNDERSCORE BLINK REVERSE HIDDEN
  do
    echo "[$ATTR]"
    ansi_set_attr $ATTR
    echo NONE
    for FG in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
    do
      ansi_set_attr $ATTR
      ansi_set_attr "FG_$FG"
      for BG in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
      do
        ansi_set_attr "BG_$BG"
        echo -n COLOR
      done
      ansi_set_attr RESET
      echo ' '
    done
  done
}

function ansi_sample() {
  for COLOR in NONE BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
  do
    for ATTR in DIM NONE BRIGHT
    do
      ansi_set_attr "$ATTR"
      ansi_set_attr "FG_$COLOR"
      echo -n $ATTR
      ansi_set_attr RESET
      echo -n ' '
    done
    echo
  done
}
