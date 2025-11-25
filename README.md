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

### macOS settings setup
```
# トラックパッド速度、Dock、Finderなどのシステム設定を自動化
chmod +x .macos
./.macos
```
**Note**: 一部の設定は再起動後に反映されます。

### Karabiner & Hammerspoon
```
# dotfilesLink.sh実行時に自動的にシンボリックリンクが作成されます
# Karabiner: ~/.config/karabiner/karabiner.json
# Hammerspoon: ~/.hammerspoon
```

### Alfred
Alfredの設定は同期フォルダを指定することで管理できます：
1. Alfred Preferences → Advanced → Syncing
2. "Set preferences folder" で任意のフォルダ（例: Dropbox）を指定
3. 複数PC間で自動的に同期されます

**Note**: Alfred Powerparkライセンスが必要です。
