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
alias chrome='google-chrome'
if [ $UID -eq 0 ]
then
  alias ls='ls --color -a'
  alias l='ls --color -lha'
  alias 1='ls -1a'
  alias rm='rm -i'
else
  alias ls='ls --color'
  alias l='ls --color -lh'
  alias 1='ls -1'
fi
alias atom='atom -n'
alias chrome='google-chrome'
alias be="bundle exec"
alias dotfiles='git --git-dir="$HOME"/src/dotfiles --work-tree="$HOME"'

# colored prompt
. ~/bin/ansi.sh
. ~/bin/ps1.sh

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

for BASHRC in "$HOME"/.bashrc.d/*.sh
do
  [ -f "$BASHRC" ] || continue
  source "$BASHRC"
done
