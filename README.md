## Overview
My configuration file.

### Install
Execute "sh dotfileLink.sh" after "git clone".

```
cd ~ 
git clone https://github.com/shuntakeuchi/dotfiles.git
cd dotfiles
sh dotfileLink.sh
```
### Emacs setup

```
brew install emacs-mac
brew install cask
cd .emacs.d
cask install
```

### brew setup
```
# install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Note: M1 MacにHomebrewをインストールしてPathを通すまで
# https://zenn.dev/tet0h/articles/a92651d52bd82460aefb
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/hoge/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

# download my Brewfile
curl -L https://raw.githubusercontent.com/shuntakeuch1/dotfiles/master/Brewfile > ./Brewfile
 
# execute brew-bundle to install those applications
brew bundle
```
