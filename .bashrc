HISTSIZE=-1
HISTFILESIZE=-1

# aliases
alias ccze='ccze -A'
alias cp='cp -ai'
alias mv='mv -i'
alias less='less -M'
alias grep='grep --color'
alias egrep='egrep --color'
alias rgrep='rgrep --color'
alias rsync='rsync -a  -H --delete -rlKHpEtS --delete --delete-excluded --force -z -v'
alias pstree='pstree -aAclnpu'
alias tailf='tail --follow=name'
if [ $UID -eq 0 ] ; then
  alias ls='ls --color -a'
  alias l='ls --color -lha'
  alias 1='ls -1a'
  alias rm='rm -i'
else
  alias root='sudo bash --rcfile "$HOME"/.bashrc'
  alias ls='ls --color'
  alias l='ls --color -lh'
  alias 1='ls -1'
fi
alias d='docker'
alias atom='atom -n'
alias a='atom -n'
alias chrome='google-chrome'
alias c='google-chrome'
alias nload='nload -a 100 -i 100000 -o 100000 -t 100 -u m -u m'
alias 808='mplayer tv:// -tv width=1280:height=720'
alias whatismypublicipaddress="curl 'https://api.ipify.org/' && echo"
alias findd="find . ! -type d -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\\n' | sort"
alias spass='/usr/bin/pwgen -cnys1 15'

# Git
alias g='git'
function git_author() {
  for f in $(git ls-files "$@")
  do
    git blame -f $f | \
      cut -d\( -f2- | \
      cut -d- -f-1 | \
      gawk 'BEGIN{FS=" +[0-9]+$"}{print $1}'
  done | \
    sort | \
    uniq -c | \
    sort -k +1n | \
    sed -r 's/^ +//g' | \
    gawk '{c=$1;TOTAL=TOTAL+c;FS="^[0-9]+ ";$0=$0;u=$2;FS=" ";USER[u]=c}END{for(u in USER){print int(USER[u]/TOTAL*100)"% "u}}' | \
    sort -k+1n
}
function gdf() {
  git diff "$1" | grep ^diff | gawk '{print $(NF-1)}' | cut -d/ -f2-
}

function git_clean_local_branches() {
  for branch in $(((git branch --remotes --format '%(refname)' | cut -d/ -f4- && git branch --format '%(refname)' | grep ^refs/heads/ | cut -d/ -f3- ) | sort | uniq -u && git branch --format '%(refname)' | grep ^refs/heads/ | cut -d/ -f3-)  | sort | uniq -d) ; do logrun git branch -D $branch ; done
}

# Dotfiles
DOTFILES_LOCAL_REPO="$HOME/src/dotfiles.git"
DOTFILES_REMOTE_REPO="git@github.com:fornellas/dotfiles.git"
if ! [ -d "$DOTFILES_LOCAL_REPO" ] && [ $UID -ne 0 ] ; then
  git clone --bare "$DOTFILES_REMOTE_REPO" "$DOTFILES_LOCAL_REPO"
  echo '*' >> "$DOTFILES_LOCAL_REPO/info/exclude"
fi
if [ $UID -ne 0 ] ; then
  alias dotfiles='git --git-dir="$DOTFILES_LOCAL_REPO" --work-tree="$HOME"'
fi

# Go
function gosetversion () {
  VERSION="$1"
  INSTALL_PREFIX="$HOME/sdk"
  INSTALL_PATH_TMP="$INSTALL_PREFIX/go"
  INSTALL_PATH="$INSTALL_PREFIX/go$VERSION"
  if ! [ -d "$INSTALL_PATH" ]
  then
    if ! rm -rf "$INSTALL_PATH_TMP"
    then
      echo "Error removing $INSTALL_PATH_TMP"
      return 1
    fi
    if ! { wget -qO- https://golang.org/dl/go"$VERSION".linux-amd64.tar.gz | tar -C "$INSTALL_PREFIX" -zx ; }
    then
      echo "Failed to download & unpack!"
      return 1
    fi
    if ! mv "$INSTALL_PATH_TMP" "$INSTALL_PATH"
    then
      echo "Error renaming."
      return 1
    fi
  fi
  export GOPATH="$HOME/go/$VERSION"
  export PATH="$INSTALL_PATH/bin:$PATH"
  export PATH="$GOPATH/bin:$PATH"
}

# Ruby
if [ -d "$HOME/.rbenv" ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
alias be="bundle exec"
alias b='bundle'
alias r='bundle exec rake'

function rrr() {
  rerun -p '{{lib,spec}/**/*.rb,*.rdoc}' -- "$@"
}

# ANSI Terminal functions
. /home/fornellas/bin/ansi_terminal.sh

function logrun() {
  ansi_set_attr BRIGHT FG_CYAN
  echo ">" "$@"
  ansi_set_attr RESET
  "$@"
}

# PS1
. /home/fornellas/bin/ps1.sh

# Editor
export EDITOR=vim

# Fix variables for root
if [ 0 -eq $UID ]
then
  unset MAIL
  HOME="$(getent passwd root | cut -d: -f6)"
  PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin"
  cd
fi

function mkbkp () {
    cp -ai "$1" "$1".$(date +%Y%m%d%H%M%S)
}

function gc_docker() {
  for id in $(docker ps -a | grep -E ' Exited \([0-9]+\)' | gawk '{print $1}') ; do docker rm $id ; done
  for id in $(docker images | grep -E '<none> +<none>' | gawk '{print $3}') ; do docker rmi $id ; done
}

function pwgen() {
  /usr/bin/pwgen --no-capitalize --numerals --symbols --ambiguous -1 "$@" 8 100000 | grep -iE '^([!@#$%12345"<>pyaoeui][&*()67890fgcrldhtns^])+$'
}

for BASHRC in "$HOME"/.bashrc.d/*.sh
do
  [ -f "$BASHRC" ] || continue
  source "$BASHRC"
done

# Python
if [ -e "$HOME/.pyenv/bin/pyenv" ]
then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  alias p=python
fi

alias rrp='rerun -p "**/*.py" -- '
alias rrc='rerun -p "**/*.{c,h,am,ac}" --'
alias rrcpp='rerun -p "**/*.{c,h,cpp}" --'

# brew
eval "$(/home/fornellas/.linuxbrew/bin/brew shellenv)"