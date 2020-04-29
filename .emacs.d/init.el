(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
(setq package-check-signature nil)
(require 'cask "/usr/local/opt/cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)
;;対話的カスタマイズをする際はファイルをわける
(setq custom-file "~/.emacs.d/user_customize.el")
(if (file-exists-p custom-file)
    (load custom-file))

;;おまじない
(require 'cl)
;;emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)
;;スタートアップメッセージを非表示
(setq inhibit-startup-screen t)
;; ビープ音を消す
(setq visible-bell t)
;; ビープ音&フラッシュを消す
;; (setq ring-bell-function 'ignore)

;; 括弧の自動挿入
(electric-pair-mode 1)

;;; Emacs Lispを書くための設定
;;; 思考錯誤用ファイル
(require 'open-junk-file)
(global-set-key (kbd "C-x C-z") 'open-junk-file)
;;; 括弧の管理
;; (require 'paredit)
;; (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-mode-hook 'enable-paredit-mode)

;; (add-hook 'lisp-interacton-mode-hook 'enable-paredit-mode)
;;; find-functionをキー割り当て ソースジャンプが可能 要は定義元ジャンプが可能
(find-function-setup-keys)
;;; C言語の情報源
(setq find-function-C-source-directory "~/Library/Caches/Homebrew/mituharu-emacs-mac-29d742efac38/src/")

;; スクリーンの最大化
;; (set-frame-parameter nil 'fullscreen 'maximized)
;; フルスクリーン
;; (set-frame-parameter nil 'fullscreen 'fullboth)
;; mac 自動 ローマ字切り替え
;;(mac-auto-ascii-mode 1)
;;;;;;; 不要だけど．．．一応
(set-language-environment "Japanese")
;; (set-default-coding-systems 'euc-japan)
;; (set-terminal-coding-system 'euc-japan)
;;; 文字コードを指定する
(prefer-coding-system 'utf-8)
;; (prefer-coding-system 'euc-japan)

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
;; (setq mac-control-modifier 'control)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save);コピー
(global-set-key (kbd "s-x") 'kill-region);切り取り
(global-set-key (kbd "s-v") 'clipboard-yank);貼り付け
(global-set-key (kbd "s-s") 'save-buffer);バッファ保存
(global-set-key (kbd "s-w") 'kill-buffer);バッファ削除

(global-set-key (kbd "C-M-s-v") 'scroll-other-window-down);次のバッファをM - v
;; インデントの行の最初の空白でない文字にポイントを移動
;;(global-set-key (kbd "C-a") 'back-to-indentation) ;;本来はM-mに割り当てられている。
;; C-mにnewline-and-indentを割り当てる。
;; 先ほどとは異なりglobal-set-keyを利用
(global-set-key (kbd "C-m") 'newline-and-indent)
;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

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

;;; ファイル名の扱い
;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))
;; バッファの終端を明示する
(setq-default indicate-empty-lines t)

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
;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）powerlineと競合?
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
;; (defun count-lines-and-chars ()
;;   (if mark-active
;;       (format "%d lines,%d chars "
;;               (count-lines (region-beginning) (region-end))
;;               (- (region-end) (region-beginning)))
;;     ;; これだとエコーエリアがチラつく
;;     ;;(count-lines-region (region-beginning) (region-end))
;;     ""))
;; (add-to-list 'default-mode-line-format
;;              '(:eval (count-lines-and-chars)))

;;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")
;; 行数表示
;; (global-display-line-numbers-mode) ; 行番号を常に表示する
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; モードラインに行番号を常に表示させる
(setq line-number-display-limit-width 10000)

;; TABの表示幅。初期値は8
(setq-default tab-width 4)
;; インデントにタブ文字を使用しない タブをスペースにする
(setq-default indent-tabs-mode nil)
;; php-modeのみタブを利用しない
;; (add-hook 'php-mode-hook
;;           '(lambda ()
;;             (setq indent-tabs-mode nil)))
;; C、C++、JAVA、PHPなどのインデント
;; (add-hook 'c-mode-common-hook
;;           '(lambda ()
;;              (c-set-style "linux")))
(defun php-mode-options ()
  (php-eldoc-enable)
  (cond
   ((string-match-p "^/my-project-folder")
    (php-eldoc-probe-load "http://my-project.com/probe.php?secret=sesame"))
   ((string-match-p "^/other-project-folder")
    (php-eldoc-probe-load "http://localhost/otherproject/probe.php?secret=sesame"))))
;; (add-hook 'php-mode-hook 'php-mode-options)

;;; 表示テーマの設定
;; (when (require 'color-theme nil t)
;;   ;; テーマを読み込むための設定
;;   (color-theme-initialize)
;;   (load-theme 'sanityinc-solarized-dark t)
;;   ;; (when (require 'color-theme-solarized)
;;   ;;   (color-theme-solarized-dark))
;;   )
(require 'color-theme-solarized)
(load-theme 'solarized-dark t)
;; (load-theme 'solarizedized-light t)

;;; これらはload-themeの前に配置すること
;; fringeを背景から目立たせる
;;(setq solarized-distinct-fringe-background t)
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
;; (load-theme 'solarized-dark t)
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
;; 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
(set-face-attribute 'show-paren-match nil
                    :background 'unspecified
                    :underline "turquoise")

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; バックアップファイルを作成しない
;; (setq make-backup-files nil)
;; オートセーブファイルを作らない
;; (setq auto-save-default nil)

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
(add-to-list 'face-font-rescale-alist '(".*icons.*" . 0.9))
(add-to-list 'face-font-rescale-alist '(".*FontAwesome.*" . 0.9))

;; company-mode 色
(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "orange")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")
(require 'company)
(require 'company-quickhelp)
(global-company-mode +1)
(company-quickhelp-mode t)
(setq company-auto-expand t) ;; 1個目を自動的に補完
(setq company-minimum-prefix-length 2) ; デフォルトは4
;; (setq company-idle-delay 0) ; 遅延なしにすぐ表示
(setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
(setq completion-ignore-case t)
(setq company-dabbrev-downcase nil)
(global-set-key (kbd "C-M-i") 'company-complete)
;; C-n, C-pで補完候補を次/前の候補を選
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
;; C-sで絞り込む
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
;; C-M-iで候補を設定
(define-key company-active-map (kbd "TAB") 'company-complete-selection)
;; (define-key company-active-map (kbd "C-M-i") 'company-complete-selection)
;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
;; (define-key php-mode-map (kbd "C-M-i") 'company-complete)
;; クイックヘルプ
;; (eval-after-load 'company
;;   '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))

;; company-mode off
(add-hook 'eshell-mode-hook (lambda () (company-mode -1)))
(add-hook 'markdown-mode-hook (lambda () (company-mode -1)))

;; (require 'company-box)
;; (add-hook 'company-mode-hook 'company-box-mode)
;; 履歴からソートする
(require 'company-statistics)
(company-statistics-mode)
(setq company-transformers '(company-sort-by-statistics company-sort-by-backend-importance))

;; yasnippetとの連携
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

(require 'company-lsp)
(push 'company-lsp company-backends)
(require 'lsp-mode)
;; python company mode
;; (add-hook 'python-mode-hook #'lsp)
(custom-set-variables
 ;; '(lsp-clients-python-library-directories '("docker:django-tutorial-app:/usr/"))
 '(lsp-clients-python-library-directories '("/usr/"))
 '(lsp-clients-php '("/usr/"))
 )

;;; Go lang settings
(add-to-list 'exec-path (expand-file-name "/usr/local/bin/go")) ;; Goのパスを通す
(add-to-list 'exec-path (expand-file-name "~/go/bin")) ;; ツールのパス
;; go-modeのときlspする
(add-hook 'go-mode-hook #'lsp-deferred)
;; go test
(require 'gotest)
(setq go-test-verbose t) ;; verboseフラグ付きでgotestする
(define-key go-mode-map (kbd "C-c C-t") 'go-test-current-file)
(define-key go-mode-map (kbd "C-c t") 'go-test-current-test)

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
;;(add-to-list 'load-path "/usr/local/Cellar/emacs/25.2/share/emacs/site-lisp/elscreen-persist.el")
;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/revive.el")
;; (load "revive")
;; (add-to-list 'load-path "script/elscreen-persist.el")
;; (load "elscreen-persist)"
(setq elscreen-prefix-key (kbd "C-z"))
(add-to-list 'load-path "~/.emacs.d/script/")
(require 'elscreen-persist)
(elscreen-persist-mode 1)
;; (when (featurep 'elscreen-persist)
;; elscreen-persist-restore のバグをリカバー
;; see also https://github.com/robario/elscreen-persist/issues/4#issuecomment-261770364
(progn
  (defun advice:elscreen-persist-restore-before-patch (&rest args)
    "elscreen-persist-restore のバグをリカバーするパッチ"
    (let ((elscreen-persist-file "~/.emacs.d/elscreen"))
      (when (file-writable-p elscreen-persist-file)
        (with-temp-buffer
          (insert-file-contents-literally elscreen-persist-file)
          (replace-string "#<" "<")
          (write-region (point-min) (point-max) elscreen-persist-file)))))
  (advice-add 'elscreen-persist-restore
              :before #'advice:elscreen-persist-restore-before-patch))
;; (elscreen-persist-mode 1)
;; )
;;

(elscreen-separate-buffer-list-mode 1)
(elscreen-start)

(global-set-key (kbd "M-<right>") 'elscreen-next)
(global-set-key (kbd "M-<left>") 'elscreen-previous)
(global-set-key (kbd "s-}") 'elscreen-next)
(global-set-key (kbd "s-{") 'elscreen-previous)

(setq save-visited-files-ignore-tramp-files t)
(turn-on-save-visited-files-mode)
;; elscreen-separate-buffer-list 版 BufferSelection の
;; bs-cycle-previous , bs-cycle-next のようなもの
;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/elscreen-separate-buffer-list-cycle.el")
;; (load "elscreen-separate-buffer-list-cycle")
(require 'elscreen-separate-buffer-list-cycle)
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

;;TRAMPでinvalid base64 エラー回避
(setq tramp-copy-size-limit nil)
;; hang対策 zshを使用しない
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

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

; 最終行に必ず改行を挿入する
(setq require-final-newline t)
;; 空白文字を強制表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")
;;;; whitespace-modeq
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
;; whitespace-mode をオン
(global-whitespace-mode t)
;; F4 で whitespace-mode をトグル
(define-key global-map (kbd "<f4>") 'global-whitespace-mode)
;; ;; 保存前に自動でクリーンアップ
(setq whitespace-action '(auto-cleanup))
;; 保存前に空白と行末を削除
(defvar delete-trailing-whitespece-before-save t)
(make-variable-buffer-local 'delete-trailing-whitespece-before-save)
(advice-add 'delete-trailing-whitespace :before-while
            (lambda () delete-trailing-whitespece-before-save))
;; auto-cleanup無効
(add-hook 'markdown-mode-hook
          '(lambda ()
             (set (make-local-variable 'whitespace-action) nil)))
;; (add-hook 'php-mode-hook
;;           '(lambda ()
;;              (set (make-local-variable 'whitespace-action) nil)))
;;; バッファの最後でnewlineで新規行を追加するのを禁止する
;; (setq next-line-add-newlines nil)

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
(setenv "LANG" "ja_JP.UTF-8")
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
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)
(setq system-uses-terminfo nil)

;;neo-tree設定
(require 'all-the-icons)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

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
(setq neo-window-width 40)

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
;;  'tabbar-default niljjj
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
      helm-echo-input-in-header-line t
      )
(setq-default helm-truncate-lines t
              helm-projectile-truncate-lines t)
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

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
;; (helm-autoresize-mode 1)

(global-set-key (kbd "C-x b") 'helm-for-files)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-g") 'helm-ag)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
;;(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(require 'helm-config)
(helm-mode 1)

; web-mode
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
  (add-to-list 'auto-mode-alist '("\\.blade.php\\'" . web-mode))
  ;;; web-modeのインデント設定用フック
  (defun web-mode-hook ()
    ;;   "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2) ; HTMLのインデイント
    ;;   (setq web-mode-css-indent-offset 2) ; CSSのインデント
    (setq web-mode-code-indent-offset 2) ; JS, PHP, Rubyなどのインデント
    ;;   (setq web-mode-comment-style 2) ; web-mode内のコメントのインデント
    (setq web-mode-style-padding 1) ; <style>内のインデント開始レベル
    (setq web-mode-script-padding 1) ; <script>内のインデント開始レベル
    (setq web-mode-engines-alist
          '(("php"    . "\\.ctp\\'"))
          )
      )
    (add-hook 'web-mode-hook  'web-mode-hook)
    )
;; (add-to-list '(web-mode-indentation-params) '("lineup-calls" . nil))

(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップモードで自動的に emmet-mode をたちあげる
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'php-mode-hook 'emmet-mode)
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces
(setq emmet-move-cursor-between-quotes t) ;; 最初のクオートの中にカーソルをぶちこむ
(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(define-key emmet-mode-keymap (kbd "s-e") 'emmet-expand-line) ;; command + e で展開
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 0)));;自動インデントなし

;;; ruby-modeのインデントを調整する
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
;; (add-hook 'ruby-mode-hook 'flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-display-errors-delay 0.3)

;; (add-hook 'ruby-mode-hook
;;           '(lambda ()
;;              (setq flycheck-checker 'ruby-rubocop)
;;              (flycheck-mode 1)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-fallback-background ((t (:background "magenta"))))
 '(helm-header ((t (:inherit header-line))))
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
(mac-auto-ascii-mode 1)

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
(define-key projectile-mode-map
  (kbd "C-c p") 'projectile-command-map)
(define-key projectile-mode-map
  (kbd "s-p s-p s-p") 'projectile-command-map)

;;;Helmを使って利用する
;; Fuzzyマッチを無効にする。
(setq helm-projectile-fuzzy-match nil)
(when (require 'helm-projectile nil t)
  (setq projectile-completion-system 'helm)
  )
(add-hook 'helm-mode-hook (lambda () (setq truncate-lines t)))

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

(setq magit-repository-directories
      '(("~/yumemi/" . 1)
        ("~/dev/" . 1)))

(setq magit-status-buffer-switch-function 'switch-to-buffer)
;; magitでinitした時は個人用のgithubに保存するようにしたい
;; [user]
;; 	name = shuntakeuch1
;; 	email = takeuchishun89@gmail.com

;;;; gitの差分表示
(when (require 'git-gutter nil t)
  (global-git-gutter-mode t)
  ;; linum-modeを利用している場合は次の設定も追加
  ;; (git-gutter:linum-setup)
  )

(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

;; (require 'auto-async-byte-compile)
;; (setq auto-async-byte-compile-exclude-files-regexp "/junk/")
;; (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

(require 'initfuncs)
(global-set-key (kbd "C-t") 'other-window-or-split)
(global-set-key (kbd "C-S-t") 'counter-other-window)
(global-set-key (kbd "s-r") 'revert-buffer-no-confirm)
(global-set-key (kbd "<f5>") 'reload-browser)
;; (global-set-key (kbd "<f5>") 'reload-curl-client)
(global-set-key (kbd "C-c 1") 'my/copy-current-path)
(global-set-key (kbd "C-c 4") 'open-finder)
(global-set-key (kbd "C-c 5") 'open-phpstorm)

(define-key global-map (kbd "M-<f8>") 'indent-whole-buffer)
(define-key global-map (kbd "M-i") 'indent-region)

;; twitter-mode
;; (load "twit-init.el")
(when (require 'twittering-mode nil t)
  ;; アイコンを表示する
  (setq twittering-icon-mode nil)
  ;; タイムラインを300秒ごとに更新する
  (setq twittering-timer-interval 300)
  ;; ;; 認証データ
  (setq twittering-account-authorization 'authorized)
  (setq twittering-oauth-access-token-alist
        '(("oauth_token" . "789882624516907008-popBUPdnF8mxeneg2NdIyyIdYGJN3GS")
          ("oauth_token_secret" . "FjRZXVl2BHPArKUfdlrfs9o3LKTRFDWWjMEpWMGBZOe5r")
          ("user_id" . "789882624516907008")
          ("screen_name" . "shuntakeuch1"))
        )
)

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
(global-set-key (kbd "C-c c") 'browse-url-with-eww)

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

(eval-after-load 'flycheck
  '(custom-set-variables
    '(flycheck-disabled-checkers '(javascript-jshint javascript-jscs))))
(defun my-js-mode-hook ()
  (setq-local electric-layout-rules
              '((?\{ . after) (?\} . before))))
(use-package js2-mode
  :mode
  (("\.js$" . js2-mode))
  :config
  )
(add-hook 'js-mode-hook 'my-js-mode-hook)
(setq js2-strict-missing-semi-warning nil)
(setq js2-missing-semi-one-line-override nil)
;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (setq my-js-mode-indent-num 2)
;;             (setq js2-basic-offset my-js-mode-indent-num)
;;             (setq js-switch-indent-offset my-js-mode-indent-num)
;;             (add-to-list 'company-backends 'company-tern)
;;             (set (make-local-variable 'company-backends)
;;                  '((company-dabbrev-code company-yasnippet company-tern)))))
(add-hook 'js2-mode-hook
          (lambda ()
            (setq my-js-mode-indent-num 2)
            (setq js2-basic-offset my-js-mode-indent-num)
            (setq js-switch-indent-offset my-js-mode-indent-num)
            ))

(setq company-tern-property-marker "")
(defun company-tern-depth (candidate)
  "Return depth attribute for CANDIDATE. 'nil' entries are treated as 0."
  (let ((depth (get-text-property 0 'depth candidate)))
    (if (eq depth nil) 0 depth)))
(add-hook 'js2-mode-hook 'tern-mode) ; 自分が使っているjs用メジャーモードに変える
;; (add-to-list 'company-backends 'company-tern) ; backendに追加
;; (add-to-list 'company-backends '(company-tern :with company-dabbrev-code))
;; (add-hook 'js-mode-hook '(lambda () (setq-local company-backends '((company-web company-css company-tern :with company-yasnippet)))))
(add-hook 'js-mode-hook
          '(lambda ()
             (setq-local company-backends '((company-tern :with company-yasnippet)))))
(add-hook 'js-mode-hook 'emmet-mode)

;; (add-to-list 'company-backends '(company-yasnippet :with company-dabbrev-code))
;; キーバインドを動的に表示 which-key
;; http://emacs.rubikitch.com/which-key/
;;; 3つの表示方法どれか1つ選ぶ
(which-key-setup-side-window-bottom)    ;ミニバッファ
;; (which-key-setup-side-window-right)     ;右端
;; (which-key-setup-side-window-right-bottom) ;両方使う
(which-key-mode 1)
;;;; 入力補助
(require 'yasnippet)
(yas-global-mode 1)


;; 日本語ドキュメントを利用するための設定
(when (require 'php-mode nil t)
  (setq php-mode-coding-style 'psr2)
  (setq php-site-url "https://secure.php.net/"
        php-manual-url 'ja))

;; php-modeのインデント設定
;; (defun php-indent-hook ()
;;   (setq indent-tabs-mode nil)
;;   (setq c-basic-offset 4)
;;   ;; (setq c-tab-width 8)
;;   ;; (setq c-argdecl-indent 0)       ; 関数の引数行のインデント
;;                                         ; 但し引数行で明示的にタブを押さない
;;   ;;                                       ; 場合は、インデントしない
;;   ;; (setq c-indent-level 8)               ; { を書いた後のインデント
;;   ;; (setq c-label-offset -4)              ; ラベルの深さ
;;   ;; (setq c-tab-always-indent t)          ; タブ記号を押した時にユーザーが
;;                                         ; 任意にタブ記号を入れることは不可
;;   (c-set-offset 'case-label '+) ; switch文のcaseラベル
;;   (c-set-offset 'arglist-intro '+) ; 配列の最初の要素が改行した場合
;;   (c-set-offset 'arglist-close 0)) ; 配列の閉じ括弧
;; (add-hook 'php-mode-hook 'php-indent-hook)

(add-hook 'php-mode-hook
          '(lambda ()
             (require 'company-php)
            (ac-php-core-eldoc-setup) ;; enable eldoc
             (set (make-local-variable 'company-backends)
                  '((company-dabbrev-code company-yasnippet)))
             (company-mode t)
             (add-to-list 'company-backends 'company-ac-php-backend t)))
(add-hook 'php-mode-hook 'php-enable-psr2-coding-style)

(require 'react-snippets)
;;;; yasnippet設定
(yas-global-mode 1)
;;; スニペット名をidoで選択する
;; (setq yas-prompt-functions '(yas-ido-prompt))

;; phpunit & quickrun
(defface phpunit-pass
  '((t (:foreground "white" :background "green" :weight bold))) nil)
(defface phpunit-fail
  '((t (:foreground "white" :background "red" :weight bold))) nil)

(defun quickrun/phpunit-outputter ()
  (save-excursion
    (goto-char (point-min))
    (while (replace-regexp "^M" "")
      nil))
  (highlight-phrase "^OK.*$" 'phpunit-pass)
  (highlight-phrase "^FAILURES.*$" 'phpunit-fail))

(quickrun-add-command "phpunit" '((:command . "phpunit")
                                  (:exec . "%c %s")
                                  (:outputter . quickrun/phpunit-outputter)))
(add-to-list 'quickrun-file-alist '("Test\\.php$" . "phpunit"))

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
    (helm-gtags-mode . "")
    ;; (flymake-mode . " Fm")
    ;; (flycheck-mode . "FC")
    (flyspell-mode . "")
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
    ;; (tern-mode . "")
    ;; Major modes
    (lisp-interaction-mode . "Li")
    (python-mode . "Py")
    (ruby-mode   . "Rb")
    (web-mode   . "W")
    (emacs-lisp-mode . "El")
    (js2-mode . "JS2")
    (helm-migemo-mode . "")
    (global-whitespace-mode . "")
    (markdown-mode . "Md")
    (editorconfig-mode . "")
    (auto-highlight-symbol-mode . "")
    ))

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

(add-hook 'dired-load-hook (lambda () (load "dired-x")))
;; beep音を消す
(defun my-bell-function ()
  (unless (memq this-command
                '(isearch-abort abort-recursive-edit exit-minibuffer
                                keyboard-quit mwheel-scroll down up next-line previous-line
                                backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)
;; macのキーボード
;; (mac-key-mode 1)

;;; symlink をフォローしない
(setq-default find-file-visit-truename t)
;; gtags-mode設定
;; (add-to-list 'load-path "/usr/local/share/gtags")
;; (autoload 'gtags-mode "gtags" "" t)
;; (setq gtags-mode-hook
;;     '(lambda ()
;;         (local-set-key "\M-t" 'gtags-find-tag)    ;関数へジャンプ
;;         (local-set-key "\M-r" 'gtags-find-rtag)   ;関数の参照元へジャンプ
;;         (local-set-key "\M-s" 'gtags-find-symbol) ;変数の定義元/参照先へジャンプ
;;         ;; (local-set-key "\C-t" 'gtags-pop-stack)   ;前のバッファに戻る
;;         ))
;; (add-hook 'c-mode-hook 'gtags-mode)
;; (add-hook 'c++-mode-hook 'gtags-mode)
;; helm-gtags設定
(require 'helm-gtags)

;; Enable helm-gtags-mode
(add-hook 'go-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'php-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'web-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'js2-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'python-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'ruby-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'c-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'c++-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'emacs-lisp-mode-hook (lambda () (helm-gtags-mode)))

;; gtag setting
(setq helm-gtags-path-style 'root)
(setq helm-gtags-auto-update t)

;; key bind
(add-hook 'helm-gtags-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-s d") 'helm-gtags-dwim)
             (local-set-key (kbd "C-c g") 'helm-gtags-select)
             (local-set-key (kbd "M-s s") 'helm-gtags-show-stack)
             (local-set-key (kbd "M-s p") 'helm-gtags-previous-history)
             (local-set-key (kbd "M-s n") 'helm-gtags-next-history)))

(defun my-eucjp-currentbuffer()
  (interactive)
  (universal-coding-system-argument))

(defun set-buffer-correct-coding-system(coding-system &optional force nomodify)
  "Correct coding system"
  (interactive
   (list (read-buffer-file-coding-system)
         current-prefix-arg))
  (let ((coding-system-for-read coding-system)
        (coding-system-for-write coding-system)
        (coding-system-require-warning t))
    (find-alternate-file buffer-file-name)))
(global-set-key (kbd "C-c 3") 'set-buffer-correct-coding-system)

;; (add-hook 'c++-mode-hook
;;   '(lambda ()
;;     (define-key c++-mode-map "\t"
;;       (lambda ()
;; 	(interactive)
;; 	(if (looking-back "\s\\|^") (c-indent-command) (command-execute 'dabbrev-expand))))))
;; Iterm2を開く
(defun cd-on-iterm ()
  (interactive)
  (util/execute-on-iterm
   (format "cd %s" default-directory)))
(defun util/execute-on-iterm (command)
  (interactive "MCommand: ")
  (do-applescript
   (format "tell application \"iTerm\"
              activate
              tell current session of current window
                write text \"%s\"
              end tell
            end tell"
           command)))

(global-set-key (kbd "C-c i") 'cd-on-iterm)

(require 'ag)
(require 'wgrep-ag)
;;; eでwgrepモードにする
(setf wgrep-enable-key "e")
;;; wgrep終了時にバッファを保存
(setq wgrep-auto-save-buffer t)
;;; read-only bufferにも変更を適用する
(setq wgrep-change-readonly-file t)

(global-set-key (kbd "C-c 2") 'camel-to-snake-backward-word)
(defun camel-to-snake-backward-word ()
  (interactive)
  (let ((case-fold-search nil)
        (s (buffer-substring
            (point) (save-excursion (forward-word -1) (point)))))
    (delete-region (point) (progn (forward-word -1) (point)))
    (insert (funcall (if (= (string-to-char s) (downcase (string-to-char s)))
                         'downcase 'upcase)
                     (replace-regexp-in-string
                      "\\([A-Z]\\)" "_\\1"
                      (store-substring s 0 (downcase (string-to-char s))))))))
;;;
(require 'helm-dash)
(setq helm-dash-docsets-path (expand-file-name "~/.docsets"))
(with-eval-after-load 'dash
  (setq helm-dash-browser-func 'browse-url-default-macosx-browser))
;; (defun py-doc ()
;;   (setq-local helm-dash-docsets '("Python 3" "Pandas" "Matplotlib" "NumPy")))
;; (defun cpp-doc ()
;;   (setq-local helm-dash-docsets '("C++" "Boost")))
;; (defun ruby-doc ()
;;   (setq-local helm-dash-docsets '("Ruby" "Ruby on Rails")))
(defun php-doc ()
  (setq-local helm-dash-docsets '("PHP" "PHPUnit" "Laravel")))
(defun el-doc ()
  (setq-local helm-dash-docsets '("Emacs\\ Lisp")))

(add-hook 'python-mode-hook 'py-doc)
(add-hook 'ruby-mode-hook 'ruby-doc)
(add-hook 'c++-mode-hook 'cpp-doc)
(add-hook 'php-mode-hook 'php-doc)
(add-hook 'emacs-lisp-mode 'el-doc)

(global-set-key (kbd "<f9>") 'help-for-help)
(global-set-key (kbd "<f1>") 'help-for-help)

(defun my-find-file-temporary-file-directory (filename)
  "ディレクトリ `temporary-file-directory'のファイルを開く"
  (interactive
   (list (read-file-name "Find files: " temporary-file-directory)))
  (find-file filename))
(global-set-key (kbd "s-,") 'my-find-file-init-el)

;; バッファ移動をわかりやすく
(beacon-mode 1)

;; Set your lisp system and, optionally, some contribs
;; (setq inferior-lisp-program "/opt/sbcl/bin/sbcl")
(setq inferior-lisp-program "/usr/local/bin/clisp")
(setq slime-contribs '(slime-fancy))

(setq auto-mode-alist
      (cons (cons "\\.cl$" 'lisp-mode) auto-mode-alist))

(slime-setup '(slime-fancy slime-company))
(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "M-.") 'company-show-location)

;; (setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:"
;;                        (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
;; (setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims")
;;                       (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))
;;php flycheck
(defun my-php-mode-hook ()
  "My PHP-mode hook."
  (require 'flycheck-phpstan)
  (flycheck-mode t)
  (flycheck-select-checker 'phpstan))

(add-hook 'php-mode-hook 'my-php-mode-hook)

(add-to-list 'company-backends 'company-web-html)

;; インクリメンタルサーチ日本語検索
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))

(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8)
;; (load-library "migemo")
(migemo-init)

;; 文字ジャンプ 日本語対応版
;; (require 'avy-migemo)
;; ;; `avy-migemo-mode' overrides avy's predefined functions using `advice-add'.
;; (avy-migemo-mode 1)
;; (global-set-key (kbd "M-g m m") 'avy-migemo-mode)
;; (setq avy-timeout-seconds nil)
;; (global-set-key (kbd "C-M-;") 'avy-migemo-goto-char-timer)

;;選択カーソルを増やすパッケージ
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; 選択項目を徐々に広げるパッケージ
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; バッファ内検索
;;; migemoなしでhelm-swoop
(helm-migemo-mode t)
(cl-defun helm-swoop-nomigemo (&key $query ($multiline current-prefix-arg))
  (interactive)
  (let (helm-migemo-mode)
    (helm-swoop :$query $query :$multiline $multiline)))

(defun isearch-forward-or-helm-swoop-or-helm-occur (use-helm-swoop)
  (interactive "p")
  (let (current-prefix-arg
        (helm-swoop-pre-input-function 'ignore))
    (call-interactively
     (case use-helm-swoop
       (1 'isearch-forward)
       ;; C-u C-sを押した場合
       ;; 1000000以上のバッファサイズならばhelm-occur、
       ;; それ以下ならばhelm-swoop
       (4 (if (< 1000000 (buffer-size)) 'helm-occur 'helm-swoop))
       ;; C-u C-u C-sでmigemoなしのhelm-swoop
       (16 'helm-swoop-nomigemo)))))
(global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop-or-helm-occur)

(require 'rainbow-delimiters)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require 'google-translate)
(defvar google-translate-english-chars "[:ascii:]’“”–"
  "これらの文字が含まれているときは英語とみなす")
(defun google-translate-enja-or-jaen (&optional string)
  "regionか、現在のセンテンスを言語自動判別でGoogle翻訳する。"
  (interactive)
  (setq string
        (cond ((stringp string) string)
              (current-prefix-arg
               (read-string "Google Translate: "))
              ((use-region-p)
               (buffer-substring (region-beginning) (region-end)))
              (t
               (save-excursion
                 (let (s)
                   (forward-char 1)
                   (backward-sentence)
                   (setq s (point))
                   (forward-sentence)
                   (buffer-substring s (point)))))))
  (let* ((asciip (string-match
                  (format "\\`[%s]+\\'" google-translate-english-chars)
                  string)))
    (run-at-time 0.1 nil 'deactivate-mark)
    (google-translate-translate
     (if asciip "en" "ja")
     (if asciip "ja" "en")
     string)))
(global-set-key (kbd "C-c t") 'google-translate-enja-or-jaen)

(defun bmi (height weight)
  "体格指数 = 体重 / (身長*身長)"
  (/ weight height height))
(defun bmi-show (height weight)
  (interactive "n身長(m): \nn体重(kg):")
  (message "身長 %.2fm 体重 %.1fkg BMI%.1f" height weight (bmi height weight)))
;; なおテーマを切り替えたら，face の設定をリロードしないと期待通りにならない
(custom-set-faces
 ;; 変換前入力時の文字列用 face
 `(mac-ts-converted-text
   ((((background dark)) :underline "orange"
     :background ,(face-attribute 'hl-line :background))
    (t (:underline "orange"
                   :background ,(face-attribute 'hl-line :background)))))
 ;; 変換対象の文字列用 face
 `(mac-ts-selected-converted-text
   ((((background dark)) :underline "orange"
     :background ,(face-attribute 'hl-line :background))
    (t (:underline "orange"
                   :background ,(face-attribute 'hl-line :background))))))
;; minibuffer では hl-line の背景色を無効にする
(when (fboundp 'mac-min--minibuffer-setup) ;; 野良ビルド用パッチの独自関数です．
  (add-hook 'minibuffer-setup-hook 'mac-min--minibuffer-setup))

;; echo-area でも背景色を無効にする．野良ビルド用パッチの独自変数です．
(setq mac-win-default-background-echo-area t) ;; *-text の background を無視

(require 'docker-tramp-compat)
(require 'phpunit)
;;; phpunit リモート実行
(add-to-list 'auto-mode-alist '("\\.php$'" . phpunit-mode))
(set-variable 'docker-tramp-use-names t)
(setq phpunit-root-directory "docker:private-laradock_workspace_1:/var/www/")
;; ((nil . ((phpunit-root-directory . "/docker:e7beb7e92a87:/var/www/"))))
(define-key php-mode-map (kbd "C-c u t") 'phpunit-current-test)
(define-key php-mode-map (kbd "C-c u c") 'phpunit-current-class)
(define-key php-mode-map (kbd "C-c u p") 'phpunit-current-project)

(setq markdown-command "multimarkdown")
(defun get-today ()
  "clipboard copy today "
  (interactive)
  (kill-new (shell-command-to-string "/bin/date +%Y年%m月%d日")))

;; plantuml.jarへのパスを設定
(setq org-plantuml-jar-path "/usr/local/Cellar/plantuml/1.2018.10/libexec/plantuml.jar")

;; org-babelで使用する言語を登録
(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)))

;;; インデントと先頭を行き来する
(defun my-move-beginning-of-line ()
  (interactive)
  (if (bolp)
      (back-to-indentation)
      (beginning-of-line)))

(global-set-key "\C-a" 'my-move-beginning-of-line)

(require 'plantuml-mode)

(setq plantuml-jar-path "/usr/local/Cellar/plantuml/1.2018.10/libexec/plantuml.jar")
(setq plantuml-output-type "png")
(add-to-list 'auto-mode-alist '("\\.pu\\'" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))


;; (add-to-list 'load-path "/your/path/to/dockerfile-mode/")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(defun open-idea ()
  (interactive)
  (let ((fPath (my/get-curernt-path)))
    (when fPath
      (shell-command-to-string (concat "open -a /Applications/IntelliJ\\ IDEA.app " fPath)))))

(add-hook 'prog-mode-hook 'flyspell-mode)

;; ispell の後継である aspell を使う。
;; CamelCase でもいい感じに spellcheck してくれる設定を追加
;; See: https://stackoverflow.com/a/24878128/8888451
(setq-default ispell-program-name "aspell")
(setq-default ispell-dictionary "english")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
(setq ispell-program-name "aspell"
  ispell-extra-args
  '("--sug-mode=ultra" "--lang=en_US" "--run-together" "--run-together-limit=5" "--run-together-min=2"))

;;; phpコード修正
;; (add-to-list 'load-path "~/.composer/vendor/bin//php-cs-fixer")
;; (require 'php-cs-fixer)
;; (add-hook 'before-save-hook 'php-cs-fixer-before-save)
(defun php-cs-fixer ()
  (interactive)
  (setq filename (buffer-file-name (current-buffer)))
  (call-process "php-cs-fixer" nil nil nil "fix" filename )
  (revert-buffer t t)
  )
;; 変数ハイライト
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

(global-set-key (kbd "C-'") #'imenu-list-smart-toggle)

;; imenu-list
;; (with-eval-after-load "imenu-list"
;;   (define-key imenu-list-major-mode-map (kbd "j") 'next-line)
;;   (define-key imenu-list-major-mode-map (kbd "k") 'previous-line))
;; (setq imenu-list-size 0.2)
;;; 選択範囲をisearch
(defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))


(global-set-key (kbd "C-c s") 'helm-swoop)
;; editorconfig モードの有効化
(editorconfig-mode 1)

(global-set-key (kbd "M-.") 'dumb-jump-go)

(if (require 'popwin nil t)
    (progn
      ;; (setq display-buffer-function 'popwin:display-buffer)
      ;; (setq popwin:popup-window-height 0.2)
      ;; (push '("\*Go Test\*" :regexp t :stick t :noselect t) popwin:special-display-config)
      ;; (push "*Shell Command Output*" popwin:special-display-config)
      ;; (push '(" *undo-tree*" :width 0.3 :position right) popwin:special-display-config)
      ;; 初期化コード
      (setq special-display-function 'popwin:special-display-popup-window)
      ;; popwinするbufferを明示的に指定
      (setq special-display-buffer-names '("\*Go Test\*","*compilation*","*quickrun*","*twittering-edit-buffer*","*eshell*"))
      )
  )

;; quickrun.el
;; https://github.com/syohex/emacs-quickrun
(require 'quickrun)
;; (push '("*quickrun*") popwin:special-display-config)
(global-set-key (kbd "<f7>") 'quickrun)

(global-auto-revert-mode 1)
;;コンバイルが正常終了したときにウインドウを自動で閉じるようにする
(bury-successful-compilation 1)
;; markdown puml livepreview
(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-livedown"))
(require 'livedown)
(custom-set-variables
 '(livedown-autostart nil) ; automatically open preview when opening markdown files
 '(livedown-open t)        ; automatically open the browser window
 '(livedown-port 1337)     ; port for livedown server
 '(livedown-browser nil))  ; browser to use
;; (global-set-key (kbd "C-M-m") 'livedown-preview)

(defun open ()
  "Open current buffer for OSX command"
  (interactive)
  (shell-command (concat "open " (buffer-file-name))))

;; (require 'lsp-mode)
;; (require 'vue-mode)
;; (require 'lsp-vue)
;; (add-hook 'vue-mode-hook #'lsp-vue-mmm-enable)
;; (add-hook 'major-mode-hook #'lsp-vue-enable)
;; (setq vetur.validation.template t)


(semantic-mode 1)
;; (add-hook ‘python-mode-hook
;; (lambda ()
;; (setq imenu-create-index-function ‘python-imenu-create-index)))

;; (set-window-margins (selected-window) 20 20)

;; (global-set-key (kbd "C-c q") 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; (setq aw-leading-char-style )

(global-set-key (kbd "<f10>") 'repeat-complex-command)

(put 'set-goal-column 'disabled nil)

;; terraform command
(require 'terraform-mode)
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

(defun tf-version ()
  "terraform version"
  (interactive)
  (let* ((buffer-name "*tfcmd*"))
    (with-output-to-temp-buffer buffer-name
      (shell-command "terraform version" buffer-name "*Messages*")
      (pop-to-buffer buffer-name))))
(defun tf-plan ()
  "terraform plan"
  (interactive)
  (let* ((buffer-name "*tfcmd*"))
    (with-output-to-temp-buffer buffer-name
      (shell-command "terraform plan" buffer-name "*stderr*")
      (pop-to-buffer buffer-name)
      )))

(defun tf-apply ()
  "Save and terraform apply"
       (interactive)
       (save-buffer)
       (shell-command "osascript ~/.emacs.d/script/iterm.scpt"))

(global-set-key (kbd "C-c u a") 'tf-apply)
(global-set-key (kbd "C-c u v") 'tf-version)
(global-set-key (kbd "C-c u p") 'tf-plan)

;;  project direnv
(require 'projectile)
(require 'projectile-direnv)
(add-hook 'projectile-mode-hook 'projectile-direnv-export-variables)

;; 動的な文字サイスの変更 +- text-scale-adust C-x C-0
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s-_") 'text-scale-decrease)

