;; ========== Emacs(on X)用のConfig ==========

;; ---------- PATH ----------
(setq exec-path (append exec-path '("/usr/local/bin")))

; C-zを抑制
(global-unset-key (kbd "C-z"))

;; ---------- FRAME and WINDOW ----------
;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 行番号
;; バッファ中の行番号表示
(global-linum-mode t)
;; 行番号のフォーマット
;; (set-face-attribute 'linum nil :foreground "red" :height 0.8)
(set-face-attribute 'linum nil :height 0.8)
(setq linum-format "%4d")

;; テーマ
(when (require 'color-theme nil t)
  (color-theme-initialize)
  (color-theme-subtle-hacker))

;; 起動時のウィンドウサイズ
;(if window-system (progn
;                    (setq initial-frame-alist '((width . 80)
;                                                (height . 70)
;                                                (top . 0)
;                                                (left . 450)
;                                                ))))
;; ウィンドウの透明化
(add-to-list 'default-frame-alist '(alpha . (0.85 0.85)))

;; スクロールバー非表示
(set-scroll-bar-mode nil)
;; ツールバー非表示
(tool-bar-mode -1)

;; 現在行をハイライト
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "#000000" t))               ;背景がdarkのときの背景色
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t)) ;背景がlightの時の背景色
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;;; 対応する括弧のハイライト
;; paren-mode: 対応する括弧を強調して表示する
(setq show-paren-delay 0)	; 表示までの秒数(初期値: 0.125)
(show-paren-mode t)			; 有効化
;; parenのスタイル
(setq show-paren-style 'expression)
; 背景色変更
;(set-face-background 'show-paren-match-face nil)
;; faceを変更する
(set-face-attribute 'show-paren-match-face nil
                    :underline "#ffff00" :weight 'bold)
(set-face-background 'show-paren-match-face nil)
(set-face-foreground 'show-paren-match-face nil)

;; ---------- FONTS ----------
;; asciiフォント
(set-face-attribute 'default nil
                    :family "Ricty"
                    :height 130)
;; 日本語フォント
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Ricty"))

;; ---------- migemo ----------
(require 'migemo)
(setq migemo-command "/usr/local/bin/cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)

;; ---------- emacs-w3m ----------
;; w3mコマンドのPATHに依存しているので、ここに
(setq w3m-command "/opt/local/bin/w3m")
(require 'w3m-load)
; alc:[検索文字列]でalc検索 (w3m-goto-url[keybind:g])
; http://mugijiru.seesaa.net/article/205303847.html
(eval-after-load "w3m-search"
  '(progn
     (add-to-list 'w3m-search-engine-alist
                  '("alc"
                    "http://eow.alc.co.jp/%s/UTF-8/"
                    utf-8))
     (add-to-list 'w3m-uri-replace-alist
                  '("\`alc:" w3m-search-uri-replace "alc"))))
(defun w3m-goto-url-empty(url)
  ""
  (interactive (list (w3m-input-url nil "" nil nil t)))
  (w3m-goto-url url))
(add-hook 'w3m-mode-hook
          (lambda()
            (define-key w3m-mode-map (kbd "g") 'w3m-goto-url-empty)))

;; ----------  ElScreen ----------
(require 'elscreen nil t)
;; ElScreenのプレフィックス(default: C-z)
(elscreen-set-prefix-key (kbd "C-t"))
;(when (require 'elscreen nil t)
;  ; C-z C-zをタイプした場合にデフォルトのC-zを利用する
;  (if window-system
;      (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
;    (define-key elscreen-map (kbd "C-z") 'suspend-emacs)))

;; ----- terminal-emulator -----
;; C-tをPrefix-keyとする
(add-hook 'terminal-mode-hook
          '(lambda()
             (define-key terminal-map (kbd "C-t")
               (lookup-key (current-global-map) (kbd "C-t")))))
(define-key term-raw-map (kbd "C-p") 'previous-line)
(define-key term-raw-map (kbd "C-n") 'next-line)