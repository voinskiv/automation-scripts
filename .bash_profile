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
  alias d='dropfile'
  alias rd='remotedesktop'
  alias rrdh='remove-rd-history'

  dropfile () { scp $1 Desktop-0$2:$3; }
  remotedesktop () { mstsc -v:Desktop-0$1 & disown; }
  remove-rd-history () {
    reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
    reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers"
    del /ah %USERPROFILE%\documents\default.rdp
  }
fi

scripts () { curl https://raw.githubusercontent.com/voinskiv/automation-scripts/main/$1 -O; }
google () { o "https://google.com/search?q=$1"; }
youtube () { o "https://youtube.com/results?search_query=$1"; }
tv () { o "https://my.tv/search/?do=search&subaction=search&q=$1"; }
