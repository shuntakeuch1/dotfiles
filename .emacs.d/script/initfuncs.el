;;; 自作関数
(defun reload-browser ()
  "Save and reload browser for Chrome"
       (interactive)
       (save-buffer)
       (shell-command "osascript ~/.emacs.d/script/reload.scpt")
       (message "complete! Reload Browser!!"))

(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive) (revert-buffer t t))

(defun counter-other-window ()
  "buffer back reverse"
  (interactive)
  (other-window -1))

(defun other-window-or-split ()
  "Other Window or split window"
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun my-find-file-init-el()
  "Open the init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun my/get-curernt-path ()
  (if (equal major-mode 'diredx-mode)
      default-directory
	(buffer-file-name)))

(defun my/copy-current-path ()
  (interactive)
  (let ((fPath (my/get-curernt-path)))
    (when fPath
      (message "stored path: %s" fPath)
      (kill-new (file-truename fPath)))))

(defun indent-whole-buffer ()
  "all buffer indent"
  (interactive)
  (indent-region (point-min) (point-max)))

(provide 'initfuncs)
