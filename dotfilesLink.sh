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

# IntelliJ IDEA
INTELLIJ_CONFIG="$HOME/Library/Application Support/JetBrains/IntelliJIdea2023.2"
mkdir -p "$INTELLIJ_CONFIG"/{keymaps,codestyles,colors,fileTemplates}
ln -sf ~/dotfiles/intellij/keymaps/* "$INTELLIJ_CONFIG/keymaps/"
ln -sf ~/dotfiles/intellij/codestyles/* "$INTELLIJ_CONFIG/codestyles/"
ln -sf ~/dotfiles/intellij/colors/* "$INTELLIJ_CONFIG/colors/"
ln -sf ~/dotfiles/intellij/fileTemplates/* "$INTELLIJ_CONFIG/fileTemplates/"
