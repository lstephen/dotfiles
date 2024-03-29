
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:/Library/Haskell/bin"

export JAVA_HOME=$(/usr/libexec/java_home)

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
orange=$(tput setaf 9)
base01=$(tput setaf 10)
reset=$(tput sgr0)

if [[ "$USER" == "root" ]]
then
  user_color=$red
else
  user_color=$green
fi

export PROMPT_DIRTRIM=5

function git_ps1() {
  fmt="$base01:$yellow%s"
  branch=`git branch 2> /dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'`
  if [ -z $branch ]
  then
    :
  else
    printf $fmt $branch
  fi
}

function rvm_ps1() {
  fmt="$base01:$blue%s"
  rvm=`rvm current`
  if [ "$rvm" == "system" ]
  then
    :
  else
    printf -- $fmt $rvm
  fi
}

export PS1='\[\033]0;\w\007\]\n\[$user_color\]\u\[$base01\]@\[$green\]\h\[$base01\]:\[$orange\]\w$(git_ps1)$(rvm_ps1)\[$base01\]\n\$ \[$reset\]'

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
alias ls="ls -G"

export STENO_THEME_TRACE=cyan

alias timestamp="date -u +%Y.%m.%d_%H.%M"
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

[[ -f ~/.git-completion.bash ]] && . ~/.git-completion.bash
[[ -f ~/.rvm/scripts/completion ]] && . ~/.rvm/scripts/completion

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

[[ $TERM_PROGRAM == 'Apple_Terminal' || $TERM_PROGRAM == 'iTerm.app' ]] && [[ ! $TERM =~ screen ]] && exec tmux -2

