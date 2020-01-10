;; twitter-mode
(when (require 'twittering-mode nil t)
  ;; アイコンを表示する
  (setq twittering-icon-mode nil)
  ;; タイムラインを300秒ごとに更新する
  (setq twittering-timer-interval 300)
  (setq twittering-account-authorization 'authorized)
  ;; 認証データ
  (setq twittering-oauth-access-token-alist
        '(("oauth_token" . "XXXXXXXXXXX")
          ("oauth_token_secret" . "XXXXXXXXXXX")
          ("user_id" . "XXXXXXXXXXX")
          ("screen_name" . "shuntakeuch1"))
        )
)
