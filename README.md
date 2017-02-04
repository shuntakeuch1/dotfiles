#個人的な.から始まる再利用するファイル群
clone
```
https://github.com/shuntakeuchi/dotfiles.git
```
ホームディレクトリでdotfileLink.shの実行
```
cd ~
sh dotfileLink.sh
```
dein.vimのインストール
```
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git ~/.vim/dein/repos/github.com/Shougo/dein.vim
```
7,10行目をユーザ名に合わせて変更
.vimrc
```
"dein Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
    endif

    " Required:
    set runtimepath^=/Users/{ユーザー名}/.vim/bundle/repos/github.com/Shougo/dein.vim

    " Required:
    call dein#begin(expand('/Users/{ユーザー名}/.vim/bundle'))
```
vim環境のインストール
```
:call dein#install()
```
