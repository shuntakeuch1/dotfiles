# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
# 環境変数
export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
LANG=en_US.UTF-8 vcs_info
RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
# Mac
alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
# Linux
alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
# Cygwin
alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
darwin*)
#Mac用の設定
#export LSCOLORS=Exfxcxdxbxegedabagacad
export CLICOLOR=1
alias ls='ls -G -F'
# colorls ver
# alias ls='colorls'
;;
linux*)
#Linux用の設定
alias ls='ls -F --color=auto'
;;
esac

# vim:set ft=zsh:
alias EM='emacsclient -t'
alias kill-emacs="emacsclient -e '(kill-emacs)'"
PATH="$HOME/.cask/bin:$PATH"
export PATH=/usr/local/sbin:$PATH #     for Homebrew↲
export PATH=/usr/local/bin:$PATH  #     for Homebrew↲
#alias middleman="bundle exec middleman"
eval "$(rbenv init -)"
# export PATH="$HOME/.exenv/bin:$PATH"
# eval "$(exenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH=$PATH:~/.composer/vendor/bin/
# gtags設定
export GTAGSCONF=/usr/local/share/gtags/gtags.conf
# export GTAGSLABEL=pygments
alias E="open -a /usr/local/Cellar/emacs-mac/emacs-26.1-z-mac-7.2/Emacs.app"
export ANDROID_HOME=/Users/takeuchishun/Library/Android/sdk
#alias ssh='~/bin/ssh-change-bg'
echo -ne "\033]0;${USER}@${LANG}\007"
#関数定義(引数3つ)
tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}

tab-reset() {
    echo -ne "\033]6;1;bg;*;default\a"
}

function chpwd() { colorls; echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"}
alias top='tab-color 134 200 0; top; tab-reset'
alias p="ping"
alias lem="~/.roswell/bin/lem"

export PIPENV_VENV_IN_PROJECT=true
alias emacslink=ln -s /usr/local/Cellar/emacs-mac/emacs-26.1-z-mac-7.2/Emacs.app /Application
export PLANTUML_LIMIT_SIZE=8192

export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"

export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on

alias dcm='docker-compose'
export PATH="$HONE/.jenv/bin:$PATH"
eval "$(jenv init -)"
export JMETER_LANGUAGE=" "

# Excel change to UTF-8
alias change-to-excel-csv='nkf --overwrite --oc=UTF-8-BOM file.csv'

# complete -C aws_completer aws

# フォントの変更
# https://medium.com/the-code-review/make-your-terminal-more-colourful-and-productive-with-iterm2-and-zsh-11b91607b98c
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir
  custom_javascript
  vcs
  newline
  status
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Create a custom JavaScript prompt section
# POWERLEVEL9K_CUSTOM_JAVASCRIPT="echo -n '\ue781' JavaScript"
# POWERLEVEL9K_CUSTOM_JAVASCRIPT_FOREGROUND="black"
# POWERLEVEL9K_CUSTOM_JAVASCRIPT_BACKGROUND="yellow"

POWERLEVEL9K_MODE='nerdfont-complete'
source  ~/powerlevel9k/powerlevel9k.zsh-theme

alias lc='colorls'

export EDITOR="vim"
eval "$(direnv hook zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/s_takeuchi/.sdkman"
[[ -s "/Users/s_takeuchi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/s_takeuchi/.sdkman/bin/sdkman-init.sh"
