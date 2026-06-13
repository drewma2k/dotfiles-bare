# Custom aliases

# editing config files
alias aliases='nvim ~/.oh-my-zsh/custom/aliases.zsh'
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.vim/vimrc'
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias dotfiles='cd ~/src/dotfiles'
alias src='cd ~/src'

# formatted date that will sort properly
alias datef='date +%Y-%m-%d'

# eza
alias eza='eza --group-directories-first'
alias ls='eza'
alias la='eza -la'
alias l='eza -l --no-filesize --no-user --no-time --no-permissions --git --git-repos'

# nvim
alias nv='nvim'

# general
alias cl='clear'
alias icat='kitten icat'

function kitty() {
  command 'kitten icat $@'
}

alias rm='rm -i'
alias lst='tree --dirsfirst -a -L 1'
