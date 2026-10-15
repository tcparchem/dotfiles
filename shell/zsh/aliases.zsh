alias lg="lazygit"
alias root="cd /"
alias home="cd ~/"

croot() {
  cd "${CODE_ROOT:-$HOME/Code}"
}

dotfiles() {
  cd "${CODE_ROOT:-$HOME/Code}/dotfiles"
}
