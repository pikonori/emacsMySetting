;;エンコード
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;;スクロール削除
(scroll-bar-mode 0)
;;ツールバー削除
(tool-bar-mode 0)
;;メニューバー削除
(menu-bar-mode 0)
;;括弧をハイライト
;;(setq show-paren-mode t)
(show-paren-mode t)

;; 括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#500")

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;;起動時の画面を削除
(setq inhibit-startup-message t)
;;Metaをaltからcommandに変更
(setq ns-command-modifier (quote meta))
;;自動改行しない
(setq-default truncate-partial-width-windows t)
(setq-default truncate-lines t)
;;tabをspace4に
(setq-default tab-width 4 indent-tabs-mode nil)

;; fullscreen
(define-key global-map (kbd "M-RET") 'ns-toggle-fullscreen)

;; C-Ret で矩形選択
;; 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
(cua-mode t)
(setq cua-enable-cua-keys nil)
(define-key global-map (kbd "C-;") 'cua-set-rectangle-mark)


;; ------------------------------------------------------------------------
;; @ key bind

;; バックスラッシュ
(define-key global-map (kbd "M-|") "\\")

;;半透明
(when (eq window-system 'mac)
  (add-hook 'window-setup-hook
            (lambda () (set-frame-parameter nil 'fullscreen 'fullboth))))


(defun mac-toggle-max-window ()
  (interactive)
  (if (frame-parameter nil 'fullscreen)
      (set-frame-parameter nil 'fullscreen nil)
    (set-frame-parameter nil 'fullscreen 'fullboth)))

;; Carbon Emacsの設定で入れられた. メニューを隠したり．
(custom-set-variables
 '(display-time-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))

(custom-set-faces)


;;Color
(if window-system (progn
		    (set-background-color "Black")
		    (set-foreground-color "LightGray")
		    (set-cursor-color "Gray")
		    (set-frame-parameter nil 'alpha 80)
		    ))



;; 行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#800"
                    :height 0.9)

;; 行番号フォーマット
(setq linum-format "%4d")

;; load pathの設定
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp")

;;補完機能
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;auto-installの導入

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  ;; インストール先を設定
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWiki に登録されている elisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))

;;redo undoを可能にする
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-_") 'redo))


(when (require 'color-moccur nil t)
  ;;グローバルマップに割当
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "¥¥.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (require 'moccur-edit nil t)
  (when (and (executable-find "cmigemo")
	     (require 'migemo nil t))
    (setq moccur-use-migemo t)))


;;anythingの設定
;;(auto-install-batch "anything")

(when (require 'anything nil t)
  (setq
   ;;候補表示するまでの時間
   anything-idle-delay 0.3
   anything-input-idle-delay 0.1
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet
   )
  (require 'anything-config nil t)
  (require 'anything-match-plugin nil t)
  (and (equal current-language-environment "Japanese")
       (executable-find "cmigemo")
       (require 'anything-migemo nil t))
  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))
  (when (require 'descbinds-anything nil t)
    (descbinds-anything-install))
  (require 'anything-grep nil t)
  (define-key global-map (kbd "C-l") 'anything)
  )

;; php用
(require 'php-mode)

(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode));*.phpのファイルのときにphp-modeを自動起動する
(add-to-list 'auto-mode-alist '("\\.ctp$" . html-mode));*.ctpのファイルのときにphp-modeを自動起動する


(add-hook 'php-mode-hook
          (lambda ()
            (require 'php-completion)
            (php-completion-mode t)
            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete) ;php-completionの補完実行キーバインドの設定
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
                               ac-source-php-completion
                               ac-source-filename
                               ))))
;;インデントに色を付ける。
;;(require 'highlight-indentation)

;;node.js用
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))


;;ruby用
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; ruby-electric.el --- electric editing commands for ruby files
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

(require 'less-css-mode)
(add-to-list 'auto-mode-alist '("\\.less$" . less-css-mode))

(add-to-list 'ac-modes 'less-css-mode)
(add-hook 'less-css-mode-hook 'ac-css-mode-setup)

;; haml-mode
(require 'haml-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))


;; ------------------------------------------------------------------------
;; @ multi-term.el

;; 端末エミュレータ
;; http://www.emacswiki.org/emacs/multi-term.el
(when (require 'multi-term nil t)
  ;(setq multi-term-program "/bin/zsh")
)


;; ------------------------------------------------------------------------
;; @ uniquify.el

;; 同名バッファを分りやすくする
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")



;; ------------------------------------------------------------------------
;; @ flymake
(require 'flymake)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")

;; ruby
;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	 (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()

	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
		 (flymake-mode))
	     ))



(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)
