if [ "$SSH_CONNECTION" ]; then PS1='\h '; else PS1=''; fi

alias f='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias s='scripts'
alias g='google'
alias y='youtube'
alias t='tv'
alias o='open .'
alias c='open -a "Visual Studio Code"'
alias ct='clear'
alias r='. ~/.bash_profile'

if [ "$OSTYPE" == "msys" ]; then
  alias i='winget install'
  alias o='start .'
  alias c='code'
  alias d='scp'
  alias rd='remotedesktop'

  remotedesktop () { mstsc -v:desktop-0$1; }
fi

scripts () { curl https://raw.githubusercontent.com/voinskiv/automation-scripts/main/$1 -O; }
google () { o "https://google.com/search?q=$1"; }
youtube () { o "https://youtube.com/results?search_query=$1"; }
tv () { o "https://my.tv/search/?do=search&subaction=search&q=$1"; }
