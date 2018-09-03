(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-blink-when-focused t)
 '(beacon-blink-when-window-changes nil)
 '(beacon-color "magenta")
 '(beacon-mode nil)
 '(company-backends
   (quote
    (company-web-html company-robe
                      (company-slime :with company-yasnippet)
                      (company-web-html :with company-yasnippet)
                      (company-jedi :with company-yasnippet)
                      (company-robe :with company-yasnippet)
                      (company-web-html :with company-yasnippet)
                      (company-robe :with company-yasnippet)
                      (company-slime :with company-yasnippet)
                      (company-web-html :with company-yasnippet)
                      (company-jedi :with company-yasnippet)
                      (company-robe :with company-yasnippet)
                      (company-bbdb :with company-yasnippet)
                      (company-eclim :with company-yasnippet)
                      (company-semantic :with company-yasnippet)
                      (company-clang :with company-yasnippet)
                      (company-xcode :with company-yasnippet)
                      (company-cmake :with company-yasnippet)
                      (company-capf :with company-yasnippet)
                      (company-files :with company-yasnippet)
                      (company-dabbrev-code company-gtags company-etags company-keywords :with company-yasnippet)
                      (company-oddmuse :with company-yasnippet)
                      (company-dabbrev :with company-yasnippet))))
 '(company-idle-delay 0.1)
 '(company-quickhelp-mode t)
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(desktop-save-mode t)
 '(flycheck-disabled-checkers (quote (javascript-jshint javascript-jscs)))
 '(git-gutter:added-sign ">")
 '(git-gutter:deleted-sign "x")
 '(git-gutter:modified-sign "*")
 '(global-company-mode t)
 '(global-whitespace-mode t)
 '(helm-gtags-auto-update t)
 '(kill-ring-max 70)
 '(magit-dispatch-arguments nil)
 '(package-selected-packages
   (quote
    (helm-company elpy company-php jinja2-mode auto-async-byte-compile open-junk-file paredit google-translate php-eldoc rainbow-delimiters helm-swoop swiper-helm avy-migemo ghub helm projectile-rails common-lisp-snippets company-lsp company-web swap-buffers helm-ag slime-company slime beacon ansible wgrep-ag ag dashboard cake2 rjsx-mode auto-yasnippet react-snippets helm-c-yasnippet yasnippet-snippets php-auto-yasnippets helm-gtags company-ansible company-tern company-statistics company-jedi save-visited-files helm-elscreen rotate direnv rspec-mode elscreen-multi-term elscreen-separate-buffer-list company-quickhelp rvm yasnippet company helm-robe yascroll color-theme-sanityinc-solarized quickrun php-mode maxframe js2-mode which-key helm-projectile zenburn-theme git-gutter abyss-theme visual-regexp wgrep color-theme-solarized package-utils helm-themes helm-dash twittering-mode dash-at-point pdf-tools emmet-mode smart-mode-line-powerline-theme solarized-theme helm-describe-modes helm-package helm-descbinds coffee-mode haskell-mode json-mode scala-mode tuareg yaml-mode counsel-projectile projectil-rails flycheck-color-mode-line web-mode vagrant-tramp use-package undohist undo-tree tabbar smex smartparens ruby-electric ruby-end prodigy popwin pallet nyan-mode nlinum neotree multiple-cursors multi-term markdown-mode magit idle-highlight-mode htmlize howm helm-rdefs flycheck-cask expand-region exec-path-from-shell elscreen drag-stuff color-theme auto-highlight-symbol all-the-icons ac-mozc))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-fallback-background ((t (:background "magenta"))))
 '(helm-header ((t (:inherit header-line))))
 '(mac-ts-converted-text ((((background dark)) :underline "orange" :background "#073642") (t (:underline "orange" :background "#073642"))))
 '(mac-ts-selected-converted-text ((((background dark)) :underline "orange" :background "#073642") (t (:underline "orange" :background "#073642"))))
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
