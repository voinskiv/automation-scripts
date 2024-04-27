if [ "$SSH_CONNECTION" ]; then PS1='\h '; else PS1=''; fi

alias f='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias g='google'
alias y='youtube'
alias t='tv'
alias o='open .'
alias c='open -a "Visual Studio Code" .'
alias r='. ~/.bash_profile'

google () { open "https://google.com/search?q=$1"; }
youtube () { open "https://youtube.com/results?search_query=$1"; }
tv () { open "https://my.tv/search/?do=search&subaction=search&q=$1"; }
