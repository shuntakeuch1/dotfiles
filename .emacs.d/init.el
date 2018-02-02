(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)

;;おまじない
(require 'cl)
;;emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)
;;スタートアップメッセージを非表示
(setq inhibit-startup-screen t)

;; スクリーンの最大化
;; (set-frame-parameter nil 'fullscreen 'maximized)
;; フルスクリーン
;; (set-frame-parameter nil 'fullscreen 'fullboth)
;; mac 自動 ローマ字切り替え
(mac-auto-ascii-mode 1)

;; for window system 半透明化
;; (if window-system
;;     (progn
;;       (set-frame-parameter nil 'alpha 100)))
;; (defun ik:toggle-opacity ()
;;   (interactive)
;;   (when window-system
;;     (ignore-errors
;;       (if (= (assoc-default 'alphna (frame-parameters)) 100)
;;           (set-frame-parameter nil 'alpha 80)
;;         (set-frame-parameter nil 'alpha 100)))))
;;起動時だけウインドウ最大化してみる
;; (require 'maxframe)
;; (add-hook 'window-setup-hook 'maximize-frame t)

;; 最近開いたファイルのリストを自動保存する
(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1))

(require 'hl-line)
;;; hl-lineを無効にするメジャーモードを指定する
(defvar global-hl-line-timer-exclude-modes '(todotxt-mode))
(defun global-hl-line-timer-function ()
  (unless (memq major-mode global-hl-line-timer-exclude-modes)
    (global-hl-line-unhighlight-all)
    (let ((global-hl-line-mode t))
      (global-hl-line-highlight))))
(setq global-hl-line-timer
      (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
;; (cancel-timer global-hl-line-timer)

;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  ;;tool-barを非表示
  (tool-bar-mode 0)
  ;;scroll-barを非表示
  (scroll-bar-mode 0))

;; CocoaEmacs以外はメニューバーを非表示
(unless (eq window-system 'ns)
  ;; menu-barを非表示
  (menu-bar-mode 0))

;; cocoa 風に変更
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save);コピー
(global-set-key (kbd "s-x") 'kill-region);切り取り
(global-set-key (kbd "s-v") 'clipboard-yank);貼り付け
(global-set-key (kbd "s-s") 'save-buffer);バッファ保存
(global-set-key (kbd "s-w") 'kill-buffer);バッファ削除
;; インデントの行の最初の空白でない文字にポイントを移動
;;(global-set-key (kbd "C-a") 'back-to-indentation) ;;本来はM-mに割り当てられている。
;; C-mにnewline-and-indentを割り当てる。
;; 先ほどとは異なりglobal-set-keyを利用
(global-set-key (kbd "C-m") 'newline-and-indent)
;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
(defun counter-other-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-t") 'other-window)
(global-set-key (kbd "C-S-t") 'counter-other-window)

;; 入力されるキーシーケンスを置き換える
;; ?\C-?はDELのキーシケンス
(keyboard-translate ?\C-h ?\C-?)

;;; パスの設定
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")
;; パスの引継ぎ
(setq exec-path-from-shell-check-startup-files nil) ;メッセージを無視する
(exec-path-from-shell-initialize)

;;; 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;;; ファイル名の扱い
;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; カラム番号も表示
(column-number-mode t)
;; ファイルサイズを表示
(size-indication-mode nil)
;; 時計を表示（好みに応じてフォーマットを変更可能）
;; (setq display-time-day-and-date t) ; 曜日・月・日を表示
;; (setq display-time-24hr-format t) ; 24時表示
;; (display-time-mode t)
;; ;; バッテリー残量を表示
;;(display-battery-mode t)
;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ;; これだとエコーエリアがチラつく
    ;;(count-lines-region (region-beginning) (region-end))
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")
;; 行番号を常に表示する
;;(global-linum-mode t)
;; バッファの左側に行番号を表示する linumより早い
;; (global-nlinum-mode t)
;; (nlinum-mode t)
;; ファイルを開いたときのみ番号表示
;; (add-hook 'find-file-hook 'linum-mode)
;; (global-set-key [f9] 'linum-mode)
;; ;; 3 桁分の表示領域を確保する
;; (setq nlinum-format "%3d")
;; モードラインに行番号を常に表示させる
(setq line-number-display-limit-width 10000)

;; TABの表示幅。初期値は8
(setq-default tab-width 4)
;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode nil)
;; php-modeのみタブを利用しない
;; (add-hook 'php-mode-hook
;;           '(lambda ()
;;             (setq indent-tabs-mode nil)))

;; C、C++、JAVA、PHPなどのインデント
(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-set-style "bsd")))
;; php-modeのswitch文のインデント
(add-hook 'php-mode-hook
          (lambda ()
            (c-set-offset 'case-label '+)))


;;; 表示テーマの設定
;; http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz
;; (when (require 'color-theme nil t)
;;   ;; テーマを読み込むための設定
;;   (color-theme-initialize)
;;   ;; テーマhoberに変更する
;;   ;;   (color-theme-molokai)) ;; 使うカラーテーマ名
;;   ;;(color-theme-hover)) ;; 使うカラーテーマ名
;;   ;; (require 'monokai-theme)
;;   (when (require 'color-theme-solarized)
;;     (color-theme-solarized-dark)))
;; (require 'color-theme-solarized)
;; (load-theme 'solarized-dark t)
;; (load-theme 'solarizedized-light t)

;;; カスタマイズできる項目！
;;; これらはload-themeの前に配置すること
;; fringeを背景から目立たせる
(setq solarized-distinct-fringe-background t)
;;
;; mode-lineを目立たせる(Fig3)
;; (setq solarized-high-contrast-mode-line t)
;;
;; bold度を減らす
;; (setq solarized-use-less-bold t)
;;
;; italicを増やす
;; (setq solarized-use-more-italic t)
;;
;; インジケータの色を減らす (git-gutter, flycheckなど)
;; (setq solarized-emphasize-indicators nil)
(load-theme 'solarized-dark t)
;; (load-theme 'sanityinc-solarized-dark t)
;;; フォントの設定

                                        ; (when (eq window-system 'ns)
                                        ;   ;; asciiフォント
(set-face-attribute 'default nil
                    :family "Ricty Diminished"
                    :height 130)
                                        ;   ;; 日本語フォントをヒラギノ明朝 Proに
                                        ;   (set-fontset-font
                                        ;    nil 'japanese-jisx0208
                                        ;    ;; 英語名の場合
                                        ;    ;; (font-spec :family "Hiragino Mincho Pro"))
                                        ;    (font-spec :family "ヒラギノ明朝 Pro"))
                                        ;   ;; ひらがなとカタカナをモトヤシーダに
                                        ;   ;; U+3000-303F	CJKの記号および句読点
                                        ;   ;; U+3040-309F	ひらがな
                                        ;   ;; U+30A0-30FF	カタカナ
                                        ;   (set-fontset-font
                                        ;    nil '(#x3040 . #x30ff)
                                        ;    (font-spec :family "NfMotoyaCedar"))
                                        ;   ;; フォントの横幅を調節する
                                        ;   (setq face-font-rescale-alist
                                        ;         '((".*Menlo.*" . 1.0)
                                        ;           (".*Hiragino_Mincho_Pro.*" . 1.2)
                                        ;           (".*nfmotoyacedar-bold.*" . 1.2)
                                        ;           (".*nfmotoyacedar-medium.*" . 1.2)
                                        ;           ("-cdac$" . 1.3))))
                                        ;
                                        ; (when (eq system-type 'windows-nt)
                                        ;   ;; asciiフォントをConsolasに
                                        ;   (set-face-attribute 'default nil
                                        ;                       :family "Consolas"
                                        ;                       :height 120)
                                        ;   ;; 日本語フォントをメイリオに
                                        ;   (set-fontset-font
                                        ;    nil
                                        ;    'japanese-jisx0208
                                        ;    (font-spec :family "メイリオ"))
                                        ;   ;; フォントの横幅を調節する
                                        ;   (setq face-font-rescale-alist
                                        ;         '((".*Consolas.*" . 1.0)
                                        ;           (".*メイリオ.*" . 1.15)
                                        ;           ("-cdac$" . 1.3))))


;; (set-fontset-font
;;     nil 'japanese-jisx0208
;;     (font-spec :family "Ricty Diminished"))
;; (set-face-font 'default "Ricty Diminished-14")

                                        ; (let ((ws window-system))
                                        ;   (cond ((eq ws 'w32)
                                        ;          (set-face-attribute 'default nil
                                        ;                              :family "Meiryo"  ;; 英数
                                        ;                              :height 100)
                                        ;          (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Meiryo")))  ;; 日本語
                                        ;         ((eq ws 'ns)
                                        ;          (set-face-attribute 'default nil
                                        ;                              :family "Ricty"  ;; 英数
                                        ;                              :height 140)
                                        ;          (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Ricty Diminished")))))  ;; 日本語
                                        ;
;; (add-to-list 'load-path "/usr/local/Cellar/emacs/25.1/share/emacs/site-lisp/skk")

;; (setq skk-tut-file "/usr/local/Cellar/emacs/25.1/share/skk/SKK.tut")
;; (require 'skk)
;; (global-set-key "\C-x\C-j" 'skk-mode)
;;(setq default-input-method "MacOSX")
;; ;; Google日本語入力を使う場合はおすすめ
;;(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "あ")
;;(require 'auto-complete)

                                        ; (defun mac-selected-keyboard-input-source-change-hook-func ()
                                        ;   ;; 入力モードが英語の時はカーソルの色をfirebrickに、日本語の時はblackにする
                                        ;   (set-cursor-color (if (string-match "\\.US$" (mac-input-source))
                                        ; 			"firebrick" "black")))
                                        ;
                                        ; (add-hook 'mac-selected-keyboard-input-source-change-hook
                                        ; 	  'mac-selected-keyboard-input-source-change-hook-func)

;; (defface my-hl-line-face
;;   ;; 背景がdarpkならば背景色を紺に
;;   '((((class color) (background dark))
;;      (:background "NavyBlue" t))
;;     ;; 背景がlightならば背景色を緑に
;;     (((class color) (background light))
;;      (:background "LightGoldenrodYellow" t))
;;     (t (:bold t)))
;;  "hl-line's my face")
;; (setq hl-line-face 'my-hl-line-face)
;; (global-hl-line-mode t)

;; 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; ファイルが #! から始まる場合、+xを付けて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode-hook用の関数を定義
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;;; Auto Complete 補完機能を利用可能にする
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/elisp/ac-dict")
  ;; (define-key ac-mode-map (kbd "TAB") 'auto-complete)
  (ac-config-default)
  (add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
  (add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
  (add-to-list 'ac-modes 'markdown-mode)  ;; fundamental-mode
  ;; (add-to-list 'ac-modes 'org-mode)
  ;; (add-to-list 'ac-modes 'yatex-mode)
  (setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
  (setq ac-ignore-case nil)
  (setq ac-delay nil)
  (setq ac-auto-show-menu nil)  ;; n秒後に補完メニューを表示
  ;; (setq ac-use-fuzzy t)          ;; 曖昧マッチ
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay nil)
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(desktop-save-mode t)
 '(git-gutter:added-sign ">")
 '(git-gutter:deleted-sign "x")
 '(git-gutter:modified-sign "*")
 '(global-company-mode t)
 '(package-selected-packages
   (quote
    (company-tern company-statistics company-jedi save-visited-files helm-elscreen rotate direnv rspec-mode elscreen-multi-term elscreen-separate-buffer-list powerline-evil company-quickhelp rvm yasnippet company helm-robe yascroll color-theme-sanityinc-solarized quickrun php-mode maxframe tern-auto-complete js2-mode which-key helm-projectile zenburn-theme git-gutter abyss-theme visual-regexp wgrep color-theme-solarized package-utils helm-themes helm-dash twittering-mode dash-at-point pdf-tools emmet-mode smart-mode-line-powerline-theme airline-themes solarized-theme helm-describe-modes helm-package helm-descbinds coffee-mode haskell-mode json-mode scala-mode tuareg yaml-mode counsel-projectile projectil-rails flycheck-color-mode-line web-mode vagrant-tramp use-package undohist undo-tree tabbar smex smartparens ruby-electric ruby-end prodigy popwin pallet nyan-mode nlinum neotree multiple-cursors multi-term markdown-mode magit idle-highlight-mode htmlize howm helm-rdefs flycheck-cask expand-region exec-path-from-shell elscreen drag-stuff color-theme auto-highlight-symbol all-the-icons ac-mozc))))

(require 'company)
(global-company-mode +1)
(global-set-key (kbd "TAB") 'company-complete)
;; C-n, C-pで補完候補を次/前の候補を選
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
;; C-sで絞り込む
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
;; TABで候補を設定
;; (define-key company-active-map (kbd "C-i") 'company-complete-selection)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)
;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
(define-key emacs-lisp-mode-map (kbd "TAB") 'company-complete)
;; クイックヘルプ
(company-quickhelp-mode +1)
;; company-mode off
(add-hook 'eshell-mode-hook (lambda () (company-mode -1)))

;; 履歴からソートする
(require 'company-statistics)
(company-statistics-mode)
(setq company-transformers '(company-sort-by-statistics company-sort-by-backend-importance))


;; ▼要拡張機能インストール▼
;;; 編集履歴を記憶する──undohist
;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;; ▼要拡張機能インストール▼
;;; アンドゥの分岐履歴──undo-tree
;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; ElScreenのプレフィックスキーを変更する（初期値はC-z）
;; (setq elscreen-prefix-key (kbd "C-t"))

(when (require 'elscreen nil t)
  ;; C-z C-zをタイプした場合にデフォルトのC-zを利用する
  ;; (if window-system
  ;;     (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
  ;;   (define-key elscreen-map (kbd "C-z") 'suspend-emacs))
  )
;; プレフィクスキーはC-z elscreen永続化
;; (add-to-list 'load-path "/usr/local/Cellar/emacs/25.2/share/emacs/site-lisp/elscreen-persist")
(require 'elscreen-persist)
(elscreen-persist-mode 1)
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-separate-buffer-list-mode 1)
(require 'elscreen-multi-term)
(global-set-key (kbd "M-<right>") 'elscreen-next)
(global-set-key (kbd "M-<left>") 'elscreen-previous)
(global-set-key (kbd "s-}") 'elscreen-next)
(global-set-key (kbd "s-{") 'elscreen-previous)
(elscreen-start)                        ;最後に書く
;;; メモ書き・ToDo管理 howm
;; (package-install 'howm)
;; howmメモ保存の場所
(setq howm-directory (concat user-emacs-directory "howm"))
;; howm-menuの言語を日本語に
(setq howm-menu-lang 'ja)
;; howmメモを1日1ファイルにする
; (setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")
;; howm-modeを読み込む
(when (require 'howm-mode nil t)
  ;; C-c,,でhowm-menuを起動
  (define-key global-map (kbd "C-c ,,") 'howm-menu))

;; howmメモを保存と同時に閉じる
(defun howm-save-buffer-and-kill ()
  "howmメモを保存と同時に閉じます。"
  (interactive)
  (when (and (buffer-file-name)
             (howm-buffer-p))
    (save-buffer)
    (kill-buffer nil)))

;; C-c C-cでメモの保存と同時にバッファを閉じる
(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)

;; cua-modeの設定
(cua-mode t) ; cua-modeをオン
(setq cua-enable-cua-keys nil) ; CUAキーバインドを無効にする

;; TRAMPでバックアップファイルを作成しない
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))
;;TRAMPでinvalid base64 エラー回避
(setq tramp-copy-size-limit nil)

;;; Emacs版manビューア（WoMan）の利用
;; キャッシュを作成
(setq woman-cache-filename "~/.emacs.d/.wmncach.el")
;; manパスを設定
(setq woman-manpath '("/usr/share/man"
                      "/usr/local/share/man"
                      "/usr/local/share/man/ja"))
;;; Helmによるman検索
;; 既存のソースを読み込む
(require 'helm-elisp)
(require 'helm-man)
;; 基本となるソースを定義
(setq helm-for-document-sources
      '(helm-source-info-elisp
        helm-source-info-cl
        helm-source-info-pages
        helm-source-man-pages))
;; helm-for-documentコマンドを定義
(defun helm-for-document ()
  "Preconfigured `helm' for helm-for-document."
  (interactive)
  (let ((default (thing-at-point 'symbol)))
    (helm :sources
          (nconc
           (mapcar (lambda (func)
                     (funcall func default))
                   helm-apropos-function-list)
           helm-for-document-sources)
          :buffer "*helm for docuemont*")))

;; s-dにhelm-for-documentを割り当て
(define-key global-map (kbd "s-d") 'helm-for-document)
;;; カーソル位置のファイルパスやアドレスを "C-x C-f" で開く
(ffap-bindings)

;; バッファを全体をインデント
(defun indent-whole-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))
;; C-<f8> でバッファ全体をインデント
(define-key global-map (kbd "M-<f8>") 'indent-whole-buffer)
;; (define-key global-map (kbd "C-i") 'indent-region)
(define-key global-map (kbd "M-i") 'indent-region)

;;;; whitespace-mode
(require 'whitespace)
;; 改行やタブを可視化する whitespace-mode
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□]) ; zenkaku space
        (newline-mark 10 [8629 10]) ; newlne
        (tab-mark 9 [187 9] [92 9]) ; tab » 187
        )
      whitespace-style
      '(spaces
        ;; tabs
        trailing
        newline
        space-mark
        tab-mark
        newline-mark))
;; whitespace-modeで全角スペース文字を可視化　
(setq whitespace-space-regexp "\\(\x3000+\\)")
;; 保存前に自動でクリーンアップ
(setq whitespace-action '(auto-cleanup))
;; whitespace-mode をオン
(global-whitespace-mode t)
;; F5 で whitespace-mode をトグル
(define-key global-map (kbd "<f4>") 'global-whitespace-mode)
;; 保存前に空白と行末を削除
(defvar delete-trailing-whitespece-before-save t)
(make-variable-buffer-local 'delete-trailing-whitespece-before-save)
(advice-add 'delete-trailing-whitespace :before-while
            (lambda () delete-trailing-whitespece-before-save))
                                        ; 空白と行末を削除 無効にしたいモードのhook
(add-hook 'markdown-mode-hook
          '(lambda ()
             (set (make-local-variable 'delete-trailing-whitespece-before-save) nil)))
;;;;

;;; Mac でファイルを開いたときに、新たなフレームを作らない
;; (setq ns-pop-up-frames nil)
(setq mac-pop-up-frames nil)            ;mac-port

  ;;; 最近閉じたバッファを復元
;; http://d.hatena.ne.jp/kitokitoki/20100608/p2
(defvar my-killed-file-name-list nil)

(defun my-push-killed-file-name-list ()
  (when (buffer-file-name)
    (push (expand-file-name (buffer-file-name)) my-killed-file-name-list)))

(defun my-pop-killed-file-name-list ()
  (interactive)
  (unless (null my-killed-file-name-list)
    (find-file (pop my-killed-file-name-list))))
;; kill-buffer-hook (バッファを消去するときのフック) に関数を追加
(add-hook 'kill-buffer-hook 'my-push-killed-file-name-list)
;; Mac の Command + z で閉じたバッファを復元する
(define-key global-map (kbd "s-z") 'my-pop-killed-file-name-list)

;;; ターミナルの利用 multi-term
;; multi-termの設定
(when (require 'multi-term nil t)
  ;; 使用するシェルを指定
  (setq multi-term-program "/usr/local/bin/zsh"))
(global-set-key (kbd "<C-M-return>") 'multi-term)

;; (setq multi-term-program shell-file-name)
;; (add-hook 'term-mode-hook '(lambda ()
;; 			     (define-key term-raw-map "\C-y" 'term-paste)
;; 			     (define-key term-raw-map "\C-q" 'move-beginning-of-line)
;; 			     (define-key term-raw-map "\C-f" 'forward-char)
;; 			     (define-key term-raw-map "\C-b" 'backward-char)
;; 			     (define-key term-raw-map "\C-tab" 'set-mark-command)
;; 			     (define-key term-raw-map (kbd "ESC") 'term-send-raw)
;; 			     (define-key term-raw-map [delete] 'term-send-raw)
;;                              (define-key term-raw-map "\C-z"
;;                                (lookup-key (current-global-map) "\C-z"))))
(global-set-key (kbd "C-c n") 'multi-term-next)
(global-set-key (kbd "C-c p") 'multi-term-prev)
;; ;; term に奪われたくないキー
(add-to-list 'term-unbind-key-list "C-t")
;; emacs に認識させたいキーがある場合は、term-unbind-key-list に追加する
;; (add-to-list 'term-unbind-key-list "C-t") ;
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)

(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)
(setq system-uses-terminfo nil)

;;neo-tree設定
(require 'all-the-icons)
(require 'neotree)
;; 隠しファイルをデフォルトで表示
(setq neo-show-hidden-files t)
;; cotrol + q でneotreeを起動
(global-set-key [f8] 'neotree-toggle) ;; neotree でファイルを新規作成した後、自動的にファイルを開く
(setq neo-create-file-auto-open t) ;; neotree ウィンドウを表示する毎に current file のあるディレクトリを表示する
(setq neo-smart-open t) ;; キーバインドをシンプルにする
;; (setq neo-keymap-style 'concise)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
                                        ; (all-the-icons-wicon "tornado" :face 'all-the-icons-blue)
                                        ; ;; delete-other-window で neotree ウィンドウを消さない
                                        ; (setq neo-persist-show t)
;; C-x }, C-x { でwindowサイズを変更できるよにする
(setq neo-window-fixed-size nil)

;; popwin との共存
                                        ; (when neo-persist-show
                                        ;   (add-hook 'popwin:before-popup-hook
                                        ;             (lambda () (setq neo-persist-show nil)))
                                        ;   (add-hook 'popwin:after-popup-hook
                                        ;             (lambda () (setq neo-persist-show t))))

;;
;; tabbarの設定
;;
;; (require 'tabbar)
;; (tabbar-mode)

;; (tabbar-mwheel-mode nil)                  ;; マウスホイール無効
;; (setq tabbar-buffer-groups-function nil)  ;; グループ無効
;; (setq tabbar-use-images nil)              ;; 画像を使わない


;; ;;----- キーに割り当てる
;; ;;(global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
;; ;;(global-set-key (kbd "<C-S-tab>") 'tabbar-backward-tab)
;; (global-set-key (kbd "<f10>") 'tabbar-forward-tab)
;; (global-set-key (kbd "<f9>") 'tabbar-backward-tab)
;; (global-set-key (kbd "M-<right>") 'tabbar-forward-tab)
;; (global-set-key (kbd "M-<left>") 'tabbar-backward-tab)
;; (global-set-key (kbd "s-}") 'tabbar-forward-tab)
;; (global-set-key (kbd "s-{") 'tabbar-backward-tab)

;; ;;----- 左側のボタンを消す
;; (dolist (btn '(tabbar-buffer-home-button
;;                tabbar-scroll-left-button
;;                tabbar-scroll-right-button))
;;   (set btn (cons (cons "" nil)
;;                  (cons "" nil))))


;; ;;----- タブのセパレーターの長さ
;; ;; (setq tabbar-separator '(1.0))


;; ;;----- タブの色（CUIの時。GUIの時は後でカラーテーマが適用）
;; (set-face-attribute
;;  'tabbar-default nil
;;  :background "brightblack"
;;  :foreground "white"
;;  )
;; (set-face-attribute
;;  'tabbar-selected nil
;;  :background "brightwhite"
;;  :foreground "#ff5f00"
;;  :box nil
;;  )
;; (set-face-attribute
;;  'tabbar-modified nil
;;  :background "brightred"
;;  :foreground "brightwhite"
;;  :box nil
;;  )

;; (when window-system                       ; GUI時
;;   ;; 外観変更
;;   (set-face-attribute
;;    'tabbar-default nil
;;    :family "MeiryoKe_Gothic"
;;    :background "#34495E"
;;    :foreground "#EEEEEE"
;;    :height 0.85
;;    )
;;   (set-face-attribute
;;    'tabbar-unselected nil
;;    :background "#34495E"
;;    :foreground "#EEEEEE"
;;    :box nil
;;    )
;;   (set-face-attribute
;;    'tabbar-modified nil
;;    :background "#E67E22"
;;    :foreground "#EEEEEE"
;;    :box nil
;;    )
;;   (set-face-attribute
;;    'tabbar-selected nil
;;    :background "#EEEEEE"
;;    :foreground "#34495E"
;;    :box nil)
;;   (set-face-attribute
;;    'tabbar-button nil
;;    :box nil)
;;   (set-face-attribute
;;    'tabbar-separator nil
;;    :height 2.0)
;;   )

;; ;;----- 表示するバッファ
;; (defun my-tabbar-buffer-list ()
;;   (delq nil
;;         (mapcar #'(lambda (b)
;;                     (cond
;;                      ;; Always include the current buffer.
;;                      ((eq (current-buffer) b) b)
;;                      ((buffer-file-name b) b)
;;                      ((char-equal ?\  (aref (buffer-name b) 0)) nil)
;;                      ((equal "*scratch*" (buffer-name b)) b) ; *scratch*バッファは表示する
;;                      ((equal "*terminal<1>*" (buffer-name b)) b) ;terminalは外す
;;                      ((equal "*terminal<2>*" (buffer-name b)) b) ;terminalは外す
;;                      ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
;;                      ((buffer-live-p b) b)))
;;                 (buffer-list))))
;; (setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

(require 'helm)
(require 'helm-config)
(require 'helm-themes)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(define-key helm-map (kbd "C-h") 'delete-backward-char)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

;; (defun spacemacs//helm-hide-minibuffer-maybe ()
;;   "Hide minibuffer in Helm session if we use the header line as input field."
;;   (when (with-helm-buffer helm-echo-input-in-header-line)
;;     (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
;;       (overlay-put ov 'window (selected-window))
;;       (overlay-put ov 'face
;;                    (let ((bg-color (face-background 'default nil)))
;;                      `(:background ,bg-color :foreground ,bg-color)))
;;       (setq-local cursor-type nil))))


;; (add-hook 'helm-minibuffer-set-up-hook
;;           'spacemacs//helm-hide-minibuffer-maybe)

                                        ; (setq helm-autoresize-max-height 0)
                                        ; (setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)
(global-set-key (kbd "C-x b") 'helm-for-files)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
;;(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(helm-mode 1)

;; web-mode
(when (require 'web-mode nil t)
  ;; 自動的にweb-modeを起動したい拡張子を追加する
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  ;;; web-modeのインデント設定用フック
  ;; (defun web-mode-hook ()
  ;;   "Hooks for Web mode."
  ;;   (setq web-mode-markup-indent-offset 2) ; HTMLのインデイント
  ;;   (setq web-mode-css-indent-offset 2) ; CSSのインデント
  ;;   (setq web-mode-code-indent-offset 2) ; JS, PHP, Rubyなどのインデント
  ;;   (setq web-mode-comment-style 2) ; web-mode内のコメントのインデント
  ;;   (setq web-mode-style-padding 1) ; <style>内のインデント開始レベル
  ;;   (setq web-mode-script-padding 1) ; <script>内のインデント開始レベル
  ;;   )
  ;; (add-hook 'web-mode-hook  'web-mode-hook)
  )

(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップモードで自動的に emmet-mode をたちあげる
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces
(setq emmet-move-cursor-between-quotes t) ;; 最初のクオートの中にカーソルをぶちこむ
(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(define-key emmet-mode-keymap (kbd "s-e") 'emmet-expand-line) ;; command + e で展開
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 0)));;自動インデントなし

;;; P172 ruby-modeのインデントを調整する
;; ruby-modeのインデント設定
(setq ;; ruby-indent-level 3 ; インデント幅を3に。初期値は2
 ruby-deep-indent-paren-style nil ; 改行時のインデントを調整する
 ;; ruby-mode実行時にindent-tabs-modeを設定値に変更
 ;; ruby-indent-tabs-mode t ; タブ文字を使用する。初期値はnil
 )
(setq ruby-insert-encoding-magic-comment nil) ;マジックコメントなし
(setq ruby-deep-indent-paren-style nil) ;Railsのインデント
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))

(require 'ruby-end)
(add-hook 'ruby-mode-hook
          '(lambda ()
             (abbrev-mode 1)
             (electric-pair-mode t)
             (electric-indent-mode t)
             (electric-layout-mode t)))
;; robe
(add-hook 'ruby-mode-hook 'robe-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))
(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))
;; ;; riなどのエスケープシーケンスを処理し、色付けする
;; (add-hook 'inf-ruby-mode-hook 'ansi-color-for-comint-mode-on)
;; (autoload 'robe-mode "robe" "Code navigation, documentation lookup and completion for Ruby" t nil)
;; (autoload 'ac-robe-setup "ac-robe" "auto-complete robe" nil nil)
;; (add-hook 'robe-mode-hook 'ac-robe-setup)
;; C-c , v RSpec実行
;; C-c , s カ-ソルが当たっているサンプルを実行
;; C-c , t Specとソースを切り替える
;; (require 'rspec-mode)
;; (eval-after-load 'rspec-mode
;;   '(rspec-install-snippets))
;; (add-hook 'after-init-hook 'inf-ruby-switch-setup)
;;; rspec-mode
;; (package-install 'rspec-mode)
;; (package-install 'direnv)

;; direnv
;; (when (require 'direnv nil t)
;;   (setq direnv-always-show-summary t)
;;   (direnv-mode))

;; rspec-modeのプレフィックスキーをs-rに変更
;; (setq rspec-key-command-prefix (kbd "s-s"))
;; rakeコマンドを利用する
;; (setq rspec-use-rake-when-possible t)
;; bundle execコマンドを利用しない
;; (setq rspec-use-bundler-when-possible nil)
;; springを利用しない
(setq rspec-use-spring-when-possible nil)
;; Dockerを利用する
;; (setq rspec-use-docker-when-possible t)
;; (setq rspec-docker-container "api")
;; (setq rspec-docker-cwd "/api/")
;; Vagrantを利用する
;; (setq rspec-use-vagrant-when-possible t)
;; (setq rspec-vagrant-cwd "/vagrant/")

(require 'flycheck)
(setq flycheck-check-syntax-automatically '(mode-enabled save))
(add-hook 'ruby-mode-hook 'flycheck-mode)
(setq flycheck-display-errors-delay 0.3)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-added ((t (:background "black" :foreground "green"))))
 '(magit-diff-added-highlight ((t (:background "white" :foreground "green"))))
 '(magit-diff-removed ((t (:background "black" :foreground "blue"))))
 '(magit-diff-removed-hightlight ((t (:background "white" :foreground "blue"))))
 '(magit-hash ((t (:foreground "red"))))
 '(nxml-comment-content-face ((t (:foreground "yellow4"))))
 '(nxml-comment-delimiter-face ((t (:foreground "yellow4"))))
 '(nxml-delimited-data-face ((t (:foreground "lime green"))))
 '(nxml-delimiter-face ((t (:foreground "grey"))))
 '(nxml-element-local-name-face ((t (:inherit nxml-name-face :foreground "medium turquoise"))))
 '(nxml-name-face ((t (:foreground "rosy brown"))))
 '(nxml-tag-slash-face ((t (:inherit nxml-name-face :foreground "grey")))))

;;Macの日本語チラツキ問題
(setq redisplay-dont-pause nil)

;;----- Macの日本語関係
;; (when (fboundp 'mac-input-source)
;;  (defun my-mac-selected-keyboard-input-source-chage-function ()
;;    (let ((mac-input-source (mac-input-source)))
;;      (set-cursor-color
;;        (if (string-match "com.apple.inputmethod.Kotoeri.Roman" mac-input-source)
;;            "Yellow" "Red"))))
;;  (add-hook 'mac-selected-keyboard-input-source-change-hook
;;            'my-mac-selected-keyboard-input-source-chage-function))
;; (when (functionp 'mac-auto-ascii-mode)  ;; ミニバッファに入力時、自動的に英語モード
;;  (mac-auto-ascii-mode 1))

;; (defun mac-selected-keyboard-input-source-change-hook-func ()
;;   ;; 入力モードが英語の時はカーソルの色をfirebrickに、日本語の時はblackにする
;;   (set-cursor-color (if (string-match "\\.US$" (mac-input-source))
;; 			"firebrick" "black")))

;; (add-hook 'mac-selected-keyboard-input-source-change-hook
;; 	  'mac-selected-keyboard-input-source-change-hook-func)
;;モードライン左側で入力タイプの確認
(defvar my:cursor-color-ime-on "#FF9300")
(defvar my:cursor-color-ime-off "#91C3FF") ;; #FF9300, #999999, #749CCC
(defvar my:cursor-type-ime-on '(bar . 2)) ;; box
(defvar my:cursor-type-ime-off '(bar . 2))

(when (fboundp 'mac-input-source)
  (defun my:mac-keyboard-input-source ()
    (if (string-match "\\.Roman$" (mac-input-source))
        (progn
          (setq cursor-type my:cursor-type-ime-off)
          (add-to-list 'default-frame-alist
                       `(cursor-type . ,my:cursor-type-ime-off))
          (set-cursor-color my:cursor-color-ime-off))
      (progn
        (setq cursor-type my:cursor-type-ime-on)
        (add-to-list 'default-frame-alist
                     `(cursor-type . ,my:cursor-type-ime-on))
        (set-cursor-color my:cursor-color-ime-on)))))

(when (and (fboundp 'mac-auto-ascii-mode)
           (fboundp 'mac-input-source))
  ;; IME ON/OFF でカーソルの種別や色を替える
  (add-hook 'mac-selected-keyboard-input-source-change-hook
            'my:mac-keyboard-input-source)
  (my:mac-keyboard-input-source))

;; たまにカーソルの色が残ってしてしまう．
;; IME ON で英文字打ったあととに，色が変更されないことがある．禁断の対処方法．
(when (fboundp 'mac-input-source)
  (run-with-idle-timer 3 t 'my:mac-keyboard-input-source))


;;PowerLineの設定
(require 'powerline)
;; (powerline-default-theme)

(set-face-attribute 'mode-line nil
                    ;; :background "#FF6699" ;背景
                    :foreground "#859900"
                    ;; :background "#859900" ;背景
                    ;; :background "#2aa198"
                    :box nil)
(set-face-attribute 'powerline-active1 nil
                    :foreground "#000"    ;文字
                    :background "#859900" ;背景
;;                     :foreground "#FF6699"
                    ;; :foreground "#859900"
;;                     :background "#003366"
                    :inherit 'mode-line)
(set-face-attribute 'powerline-active2 nil
                    ;; :foreground "#859900"
;;                     :foreground "#000"
;;                     :background "#888888"
;;                     ;; :background "#ffaeb9"
                    :inherit 'mode-line)

;; (set-face-attribute 'mode-line-inactive nil
;;                     :foreground "#fff"
;;                     :background "#FF6699"
;;                     ;; :foreground "#000"
;;                     ;; :background "#ffaeb9"
;;                     :box nil)
;; (set-face-attribute 'powerline-inactive1 nil
;;                     :foreground "#000"
;;                     :background "#888888"
;;                     ;; :background "#ffaeb9"
;;                     :inherit 'mode-line)
;; (set-face-attribute 'powerline-inactive2 nil
;;                     :foreground "#FF6699"
;;                     :background "#003366"
;;                     :inherit 'mode-line)
(setq mac-use-srgb-colorspace nil)      ;powerline綺麗に表示されない問題
(setq powerline-height 15)
(setq powerline-raw " ")


;; projectile
(when (require 'projectile nil t)
  ;;自動的にプロジェクト管理を開始
  (projectile-mode)
  ;; プロジェクト管理から除外するディレクトリを追加
  (add-to-list
   'projectile-globally-ignored-directories
   "node_modules")
  ;; プロジェクト情報をキャッシュする
  (setq projectile-enable-caching t))

;; projectileのプレフィックスキーをs-pに変更
(define-key projectile-mode-map
  (kbd "s-p") 'projectile-command-map)

;;;Helmを使って利用する
;; Fuzzyマッチを無効にする。
(setq helm-projectile-fuzzy-match nil)
(when (require 'helm-projectile nil t)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

;; railsサポート
;; (require 'projectile-rails)
;; (add-hook 'projectile-mode-hook 'projectile-rails-on)
;; projectile-railsのプレフィックスキーをs-rに変更
;; (setq projectile-rails-keymap-prefix (kbd "s-r"))
(when (require 'projectile-rails nil t)
  (projectile-rails-global-mode))

;; neotreeはprojectileが有効の場合 projectileのrootディレクトリを展開する
(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (projectile-project-root))
        (file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
        (if (neo-global--window-exists-p)
            (progn
              (neotree-dir project-dir)
              (neotree-find file-name)))
      (message "Could not find git project root."))))
(global-set-key [f8] 'neotree-project-dir)

;; tramp sudo利用 /ssh:sudo:$hostname:$directory
;; (add-to-list 'tramp-default-proxies-alist
;;              '(nil "\\`root\\'" "/ssh:%h:"))
;; (add-to-list 'tramp-default-proxies-alist
;;              '("localhost" nil nil))
;; (add-to-list 'tramp-default-proxies-alist
;;              '((regexp-quote (system-name)) nil nil))
;; magit
(global-set-key (kbd "C-x g") 'magit-status)


(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;;; gitの差分表示
(when (require 'git-gutter nil t)
  (global-git-gutter-mode t)
  ;; linum-modeを利用している場合は次の設定も追加
  ;; (git-gutter:linum-setup)
  )

(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

;;chrome更新save-rehash
(defun reload-browser ()"Save and reload browser"
       (interactive)
       (save-buffer)
       (shell-command "osascript ~/.emacs.d/script/reload.scpt")
       )
(global-set-key (kbd "<f5>") 'reload-browser)

;; PDF出力
;; (setq my-pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
;; (defun my-pdfout-region (begin end)
;;     (interactive "r")
;;     (shell-command-on-region begin end (format my-pdfout-command-format (read-from-minibuffer "File name:"))))
;; (defun my-pdfout-buffer ()
;;     (interactive)
;;     (my-pdfout-region (point-min) (point-max)))

;; ドキュメント検索 Dash 連携
;; dash-at-point
(global-set-key (kbd "C-c d") 'dash-at-point)
(global-set-key (kbd "C-c e") 'dash-at-point-with-docset)
                                        ; web-modeのときのDocsetはhtmlとする
(add-to-list 'dash-at-point-mode-alist '(web-mode . "html"))

;; twitter-mode
(require 'twittering-mode)
(setq twittering-use-master-password t)

;; nxml-mode
(use-package nxml-mode
  :mode
  (("\.xml$" . nxml-mode)
   ("\.xsl$" . nxml-mode)
   ("\.xhtml$" . nxml-mode)
   ("\.page$" . nxml-mode))
  :config
  (setq nxml-child-indent 2)                  ; タグのインデント幅
  (setq nxml-attribute-indent 2)              ; 属性のインデント幅
  (setq indent-tabs-mode nil)
  (setq nxml-slash-auto-complete-flag t)      ; </の入力で閉じタグを補完する
  (setq tab-width 2)


  (custom-set-faces
   ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
   ;; Your init file should contain only one such instance.
   '(nxml-comment-content-face ((t (:foreground "yellow4"))))
   '(nxml-comment-delimiter-face ((t (:foreground "yellow4"))))
   '(nxml-delimited-data-face ((t (:foreground "lime green"))))
   '(nxml-delimiter-face ((t (:foreground "grey"))))
   '(nxml-element-local-name-face ((t (:inherit nxml-name-face :foreground "medium turquoise"))))
   '(nxml-name-face ((t (:foreground "rosy brown"))))
   '(nxml-tag-slash-face ((t (:inherit nxml-name-face :foreground "grey")))))
  )
(setq-default case-fold-search nil) ;大文字小文字を区別する
;; (setq-default case-fold-search t)   ;大文字小文字を区別しない
;; 正規表現置換
;; (setq-default case-replace nil)
(global-set-key (kbd "M-%") 'vr/query-replace)
;; テキストブラウザ eww
(defvar eww-disable-colorize t)
(defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
  (unless eww-disable-colorize
    (funcall orig start end fg)))
(advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
(advice-add 'eww-colorize-region :around 'shr-colorize-region--disable)
(defun eww-disable-color ()
  "eww で文字色を反映させない"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))
(defun eww-enable-color ()
  "eww で文字色を反映させる"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))

(setq eww-search-prefix "http://www.google.co.jp/search?q=")

(defun eww-mode-hook--rename-buffer ()
  "Rename eww browser's buffer so sites open in new page."
  (rename-buffer "eww" t))
(add-hook 'eww-mode-hook 'eww-mode-hook--rename-buffer)
;; エラー回避
;; (use-package eww
;;   :config
;;   (bind-keys :map eww-mode-map
;;              ("h" . backward-char)
;;              ("j" . next-line)
;;              ("k" . previous-line)
;;              ("l" . forward-char)
;;              ("J" . View-scroll-line-forward)  ;; カーソルは移動せず、画面がスクロースする
;;              ("K" . View-scroll-line-backward)
;;              ("s-[" . eww-back-url)
;;              ("s-]" . eww-forward-url)
;;              ("s-{" . previous-buffer)
;;              ("s-}" . next-buffer)
;;              )
;;   )

;; (define-key eww-mode-map "r" 'eww-reload)
;; (define-key eww-mode-map "c 0" 'eww-copy-page-url)
;; (define-key eww-mode-map "p" 'scroll-down)
;; (define-key eww-mode-map "n" 'scroll-up)

(defun eww-search (term)
  (interactive "sSearch terms: ")
  (setq eww-hl-search-word term)
  (eww-browse-url (concat eww-search-prefix term)))

(add-hook 'eww-after-render-hook (lambda ()
                                   (highlight-regexp eww-hl-search-word)
                                   (setq eww-hl-search-word nil)))

(defun browse-url-with-eww ()
  (interactive)
  (let ((url-region (bounds-of-thing-at-point 'url)))
    ;; url
    (if url-region
        (eww-browse-url (buffer-substring-no-properties (car url-region)
                                                        (cdr url-region))))
    ;; org-link
    (setq browse-url-browser-function 'eww-browse-url)
    (org-open-at-point)))
(global-set-key (kbd "C-c p") 'browse-url-with-eww)

(defun eww-disable-images ()
  "eww で画像表示させない"
  (interactive)
  (setq-local shr-put-image-function 'shr-put-image-alt)
  (eww-reload))
(defun eww-enable-images ()
  "Eww で画像表示させる"
  (interactive)
  (setq-local shr-put-image-function 'shr-put-image)
  (eww-reload))
(defun shr-put-image-alt (spec alt &optional flags)
  (insert alt))
;; はじめから非表示
(defun eww-mode-hook--disable-image ()
  (setq-local shr-put-image-function 'shr-put-image-alt))
(add-hook 'eww-mode-hook 'eww-mode-hook--disable-image)

;;;;javascript
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;; 標準のjs-mode
;; (defun js-indent-hook ()
;;   ;; インデント幅を4にする
;;   (setq js-indent-level 2
;;         js-expr-indent-offset 2
;;         indent-tabs-mode nil)
;;   ;; switch文のcaseラベルをインデントする関数を定義する
;;   (defun my-js-indent-line () ←(d1)
;;          (interactive)
;;          (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
;;                 (offset (- (current-column) (current-indentation)))
;;                 (indentation (js--proper-indentation parse-status)))
;;            (back-to-indentation)
;;            (if (looking-at "case\\s-")
;;                (indent-line-to (+ indentation 2))
;;              (js-indent-line))
;;            (when (> offset 0) (forward-char offset))))
;;   ;; caseラベルのインデント処理をセットする
;;   (set (make-local-variable 'indent-line-function) 'my-js-indent-line)
;;   ;; ここまでcaseラベルを調整する設定
;;   )

;; ;; js-modeの起動時にhookを追加
;; (add-hook 'js-mode-hook 'js-indent-hook)

;;; 構文チェック機能を備えたjs2-mode
;; (package-install 'js2-mode)
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; React（JSX）を使う場合はこちら
;; (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))

(defun my-js-mode-hook ()
  (setq-local electric-layout-rules
              '((?\{ . after) (?\} . before))))

(add-hook 'js-mode-hook 'my-js-mode-hook)
(use-package js2-mode
  :mode
  (("\.js$" . js2-mode))
  :config
  )
;; (use-package jquery-doc
;;   :commands (jquery-doc-setup)
;;   :init
;;   (add-hook 'js2-mode-hook 'jquery-doc-setup))
;; (use-package tern
;;   :commands (tern-mode)
;;   :init
;;   (add-hook 'js2-mode-hook 'tern-mode)
;;   :config
;;   )
;; (eval-after-load 'tern
;;   '(progn
;;      (require 'tern-auto-complete)
;;      (tern-ac-setup)))
(setq company-tern-property-marker "")
(defun company-tern-depth (candidate)
  "Return depth attribute for CANDIDATE. 'nil' entries are treated as 0."
  (let ((depth (get-text-property 0 'depth candidate)))
    (if (eq depth nil) 0 depth)))
(add-hook 'js2-mode-hook 'tern-mode) ; 自分が使っているjs用メジャーモードに変える
(add-to-list 'company-backends 'company-tern) ; backendに追加
(add-to-list 'company-backends '(company-tern :with company-dabbrev-code))

;; キーバインドを動的に表示 which-key
;; http://emacs.rubikitch.com/which-key/
;;; 3つの表示方法どれか1つ選ぶ
(which-key-setup-side-window-bottom)    ;ミニバッファ
;; (which-key-setup-side-window-right)     ;右端
;; (which-key-setup-side-window-right-bottom) ;両方使う
(which-key-mode 1)
;;;; 入力補助
;; (require 'yasnippet)
;; (yas-global-mode 1)
;; 括弧の自動挿入
(electric-pair-mode 1)

;;;; バッファーの読み込み
;; (defun revert-buffer-no-confirm ()
;;     "Revert buffer without confirmation."
;;     (interactive) (revert-buffer t t))

;; (global-set-key (kbd "C-c C-r") 'revert-buffer-no-confirm)
;; (global-auto-revert-mode 1)

;; reload buffer
(global-set-key (kbd "s-r") 'revert-buffer-no-confirm)
;; (global-set-key "\M-r" 'revert-buffer-no-confirm) ;

;; 日本語ドキュメントを利用するための設定
(when (require 'php-mode nil t)
  (setq php-site-url "https://secure.php.net/"
        php-manual-url 'ja))
;; php-modeのインデント設定
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  ;; (c-set-offset 'case-label '+) ; switch文のcaseラベル
  (c-set-offset 'arglist-intro '+) ; 配列の最初の要素が改行した場合
  (c-set-offset 'arglist-close 0)) ; 配列の閉じ括弧

(add-hook 'php-mode-hook 'php-indent-hook)
;; スクロール
(require 'yascroll)
(global-yascroll-bar-mode 1)

;; マイナーモードの短縮
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (yas-minor-mode . "")
    (paredit-mode . " Pe")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (undo-tree-mode . "")
    (elisp-slime-nav-mode . " EN")
    (helm-gtags-mode . " HG")
    ;; (flymake-mode . " Fm")
    (flycheck-mode . "")
    (git-gutter-mode . "")
    (helm-mode . "")
    (which-key-mode . "")
    (company-mode . "")
    (auto-complete-mode . "")
    (projectile-rails-mode . "")
    (emmet-mode . "")
    (auto-revert-mode . "")
    ;; (robe-mode . "")
    (ruby-end-mode . "")
    (tern-mode . "")
    ;; Major modes
    (lisp-interaction-mode . "Li")
    (python-mode . "Py")
    (ruby-mode   . "Rb")
    (web-mode   . "W")
    (emacs-lisp-mode . "El")
    (js2-mode . "JS2")
    (markdown-mode . "Md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)
;; 終了を確認する
(setq confirm-kill-emacs 'y-or-n-p)
;;; exec-path に PATH を追加する emacs実践入門ver
;; (cl-loop for x in (reverse
;;                 (split-string (substring (shell-command-to-string "echo $PATH") 0 -1) ":"))
;;       do (add-to-list 'exec-path x))
;; オートコンプリートオフ
;; (auto-complete-mode -1)

;; python 自動補完
;; auto-complete用
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)                 ; optional
;; (setq jedi:environment-root "~/.emacs.d/var/jedi/env") ;環境が作られる先
;; compay-mode
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi) ; backendに追加

;; ファイル名の取得
(defun my/get-curernt-path ()
  (if (equal major-mode 'dired-mode)
      default-directory
	(buffer-file-name)))

(defun my/copy-current-path ()
  (interactive)
  (let ((fPath (my/get-curernt-path)))
    (when fPath
      (message "stored path: %s" fPath)
      (kill-new (file-truename fPath)))))

(global-set-key (kbd "C-c 0") 'my/copy-current-path)

;;; symlink をフォローしない
(setq-default find-file-visit-truename t)


;;; elscreen-separate-buffer-list-cycle.el
;;
;; elscreen-separate-buffer-list 版 BufferSelection の
;; bs-cycle-previous , bs-cycle-next のようなもの
;;
;; Author: garin <garin54@gmail.com>
;; Version: 0.0.3
;; Date: 2017.09.10
;;

;; License:
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;
;; == 必要
;; * elscreen
;; * elscreen-separate-buffer-list-mode
;;
;; == 使い方
;; ファイルを適当なディレクトリに保存して、
;; elscreen-separate-buffer-list-mode を読み込んだ後で
;; (load "/path/to/elscreen-separate-buffer-list-cycle.el")
;;
;; === 機能
;; \C-. : ebc-switch-to-next-buffer
;; 次のバッファに移動
;; 最後のバッファの時は最初のバッファに移動
;;
;; \C-, :  ebc-switch-to-prev-buffer
;; 前のバッファに移動
;; 最初のバッファの時は最後のバッファに移動
;;
;; == 解説
;; elscreen のスクリーンごとにバッファリストをサイクルする
;;
;; bs-cycle では buffer-list を対象に移動するので、elscreen で複数のスクリーンを
;; 使っていてもすべてのスクリーンでバッファリストが共有され
;; スクリーン B で開いたファイルもスクリーン A でサイクルされていた
;;
;; ebc-cycle では elscreen separate の buffer list(ido-buffer-list) を
;; 使うことでスクリーンごとにバッファのサイクルを制御します
;;
;; == bs-cycle
;; buffer-list 経由なので 全部のスクリーンでバッファリストが共有
;;
;; screnA : buffer1 buffer2 buffer3 buffer4 buffer5
;; screnB : buffer1 buffer2 buffer3 buffer4 buffer5
;; screnC : buffer1 buffer2 buffer3 buffer4 buffer5
;;
;; == ebc-cycle
;; elscreen separate buffer list (ido-buffer-list) 経由なので
;; スクリーンごとにバッファリストが独立
;;
;; screnA : buffer1 buffer2 buffer4 buffer5
;; screnB : buffer3 buffer4
;; screnC : buffer1 buffer2 buffer6
;;
;; (独立してるので同じバッファが複数のスクリーンに存在しても問題ない)
;;
;; == バグ
;; * ebc-boring-buffer-regexp-list で除外したバッファがカレントバッファの時にバッファの移動ができない
;;
;; == 更新履歴
;;
;; == メモ
;; 似たような機能が探してもなかったので作りました。
;; もっといい実装してるのがあれば教えてください
(require 'elscreen-separate-buffer-list)

;; 無視するバッファの正規表現リスト
(defvar ebc-boring-buffer-regexp-list '())
;; (setq ebc-boring-buffer-regexp-list '("\\*.*" "ipa_file"))
(setq ebc-boring-buffer-regexp-list '("\\*.*" "\\*helm.*" "\\*Message" "\\*Compile" "\\Buffer List\\*" "\\*howm" "ipa_file"))

;; swith-buffer のたびに
;; 1つ前と現在のバッファをリストの先頭に移動
;; ebc-previous-buffer で直前のバッファに移動できるようにするため
(defun esbl-add-separate-buffer-list (buffer)
  "SEPARATE-BUFFER-LIST に BUFFER を加える."
  (esbl-remove-separate-buffer-list ebc-before-current-buffer)
  (if (member buffer (esbl-get-separate-buffer-list))
      (esbl-remove-separate-buffer-list buffer))
  (setq esbl-separate-buffer-list (append (list ebc-before-current-buffer) (esbl-get-separate-buffer-list)))
  (setq esbl-separate-buffer-list (append (list buffer) (esbl-get-separate-buffer-list)))
  (setq esbl-separate-buffer-list (remove-duplicates esbl-separate-buffer-list))
  (esbl-separate-buffer-list-count-inc buffer))

;; switch-to-buffer する前のカレントバッファを保存
(defvar ebc-before-current-buffer (current-buffer))
(defun ebc-get-before-current-buffer (buffer &rest _)
    (setq ebc-before-current-buffer (current-buffer))
  )
(advice-add 'switch-to-buffer :before 'ebc-get-before-current-buffer)

;; ebc 用の switch-buffer
(defun ebc-switch-to-buffer(buffer)
  ;; ebc で switch to buffer すの時は ebc-before-current-buffer, esbl-add-separate-buffer-list を実行しない
  (advice-remove 'switch-to-buffer 'ebc-get-before-current-buffer)
  (advice-remove 'switch-to-buffer 'esbl-add-separate-buffer-list:advice)
  (switch-to-buffer buffer)
  (advice-add 'switch-to-buffer :before 'ebc-get-before-current-buffer)
  (advice-add 'switch-to-buffer :after 'esbl-add-separate-buffer-list:advice)
  )

;; バッファ名が ebc-boring-buffer-regexp-list の正規表現に一致すれば t
(defun ebc-is-boring-buffer(buffer-name)
  (loop for r in ebc-boring-buffer-regexp-list
        if (string-match r buffer-name)  return t)
  )

;; バッファのリストの取得
(defun ebc-get-buffer-list()
  (loop for b in (esbl-get-separate-buffer-list)
        if (not (ebc-is-boring-buffer (buffer-name b))) collect b)
  )

;; バッファリストを表示
(defun ebc-show-buffer-list (&optional arg)
  (interactive "P")
  (message (format "%s" (ebc-get-buffer-list)))
  )

;; 現在のバッファが buffer-list のどの位置にあるかを返す
(defun ebc-current-buffer-nth()
  (let (buffers)
    (setq buffers (ebc-get-buffer-list))
    (loop for i from 0 to (length buffers)
          if (equal (nth i buffers) (current-buffer)) return i))
  )

;; 1つ前のバッファを返す
;; 一番最初のバッファなら最後のバッファを返す
(defun ebc-previous-buffer()
  (let (ebc-next-buffer-nth)
    (if (= (ebc-current-buffer-nth) (- (length (ebc-get-buffer-list)) 1) )
        (setq ebc-next-buffer-nth 0)
      (setq ebc-next-buffer-nth (+ (ebc-current-buffer-nth) 1))
      )
    ;; (message (format "%s" ebc-next-buffer-nth))
    ;; (message (format "%s" (ebc-get-buffer-list)))
    (nth ebc-next-buffer-nth (ebc-get-buffer-list))
    )
  )

;; 1つ次のバッファを返す
;; 一番最後のバッファなら最初のバッファを返す
(defun ebc-next-buffer()
  (let (ebc-previous-buffer-nth)
    (if (< (ebc-current-buffer-nth) 1)
        (setq ebc-previous-buffer-nth
              (- (length (ebc-get-buffer-list)) 1))
      (setq ebc-previous-buffer-nth (- (ebc-current-buffer-nth) 1)))
    ;; (message (format "%s" ebc-previous-buffer-nth))
    ;; (message (format "%s" (ebc-get-buffer-list)))
    (nth ebc-previous-buffer-nth (ebc-get-buffer-list))
    )
  )

;; 1つ前のバッファに移動
(defun ebc-switch-to-previous-buffer (&optional arg)
  (interactive "P")
  (ebc-switch-to-buffer (ebc-previous-buffer))
  )

;; 1つ後のバッファに移動
(defun ebc-switch-to-next-buffer (&optional arg)
  (interactive "P")
  (ebc-switch-to-buffer (ebc-next-buffer))
  )

;; キーバインド
(global-set-key [?\C-.] 'ebc-switch-to-next-buffer)
(global-set-key [?\C-,] 'ebc-switch-to-previous-buffer)

;; (global-set-key (kbd "s-c") 'clipboard-kill-ring-save);コピー
