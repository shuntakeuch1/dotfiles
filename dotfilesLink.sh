ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/.emacs.d ~/.emacs.d
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/Brewfile ~/Brewfile

# Karabiner
mkdir -p ~/.config/karabiner
ln -sf ~/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

# Hammerspoon
ln -sf ~/dotfiles/hammerspoon ~/.hammerspoon
