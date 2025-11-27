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

### Karabiner & Hammerspoon (ShiftIt)
```
# dotfilesLink.sh実行時に自動的にシンボリックリンクが作成されます
# Karabiner: ~/.config/karabiner/karabiner.json
# Hammerspoon + ShiftIt: ~/.hammerspoon
```

**ShiftItのショートカット（ウィンドウ管理）:**
- `Ctrl + Alt + Left`: ウィンドウを左半分に配置
- `Ctrl + Alt + Right`: ウィンドウを右半分に配置
- `Ctrl + Cmd + Up`: ウィンドウを最大化
- `Ctrl + Cmd + N`: 次のスクリーンに移動

### IntelliJ IDEA
IntelliJ IDEAの以下の設定を管理しています：
- **キーマップ** (`keymaps/`): カスタムキーバインド設定
- **コードスタイル** (`codestyles/`): フォーマット設定（GoogleStyleなど）
- **カラースキーム** (`colors/`): エディタの配色設定
- **ファイルテンプレート** (`fileTemplates/`): 新規ファイル作成時のテンプレート

```bash
# dotfilesLink.sh実行時に自動的にシンボリックリンクが作成されます
# 対象: IntelliJ IDEA 2023.2
```

**Note**: 
- ライセンスキー（`idea.key`）やトークン（`user.web.token`）は除外されています
- バージョンアップ時は`dotfilesLink.sh`のパスを更新してください

### Alfred
Alfredの設定をdotfilesで管理しています：
- **preferences/**: 一般設定、ホットキー、外観など
- **themes/**: カスタムテーマ（4種類）

```bash
# Alfredの設定を適用（手動でコピー）
cp -r ~/dotfiles/alfred/Alfred.alfredpreferences/* ~/Library/Application\ Support/Alfred/Alfred.alfredpreferences/
```

**Note**: 
- Alfred Powerparkライセンスが必要です（ライセンスファイルは除外されています）
- **workflows/は除外**：個人情報やAPIキーが含まれる可能性があるため
- Spotlightは無効化されています（`.macos`で設定、Alfredを⌘Spaceで起動）

**workflowsの同期方法**: Alfred Preferences → Advanced → Syncing で同期フォルダを指定することを推奨
