HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

zstyle :compinstall filename '~/.zshrc'
clear && catnap
autoload -Uz compinit
compinit

# Alias

alias calculator='quich'
alias c='quich'
alias calc='quich'
alias ff='clear && catnap'
alias uninstall='sudo pacman -R'
alias update='sudo pacman -Syu'
alias fucking='sudo'
alias home='cd ~'
# source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"



