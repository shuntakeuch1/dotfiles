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

(provide 'elscreen-separate-buffer-list-cycle)
