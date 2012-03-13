(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))

(add-hook 'slime-repl-mode-hook
          (defun clojure-mode-slime-font-lock ()
            (let (font-lock-mode)
              (clojure-mode-font-lock-setup))))

;;; Set Cmd as Meta key
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;;; CDT-Emacs Clojure debug
(setq cdt-dir "/Users/mepihlaj/.lein/cdt")
;; (setq cdt-source-path (let ((src-root "/Users/mepihlaj/.lein/cdt/src")) (format "%s/clojure-1.2.0/src/jvm:%s/clojure-1.2.0/src/clj:%s/clojure-contrib-1.2.0/src/main/clojure:" src-root src-root src-root)))
;; (load-file "/Users/mepihlaj/.lein/cdt/cdt.el")

(defun cdt-query-cmdline ()
  (let ((path (strip-trail cdt-dir)))
    (format "java -classpath%s clojure.main --repl"
            (mapconcat 'identity (directory-files (format "%s/lib" cdt-dir) t ".jar$") ":"))))


;;; Geiser scheme
(load-file "~/projects/scheme/geiser/elisp/geiser.el")
(add-hook 'geiser-racket-mode-hook (lambda () (paredit-mode +1)))
(setq geiser-active-implementations '(racket))

;;; set smaller font . OS X
(set-default-font "-apple-Monaco-medium-normal-normal-*-10-*-*-*-m-0-iso10646-1")

;;; undo-tree mode
(require 'undo-tree)
(global-undo-tree-mode)

;;; textmate mode https://github.com/tanoku/textmate.el
(require 'textmate)
(textmate-mode)

;; yasnippets
(add-to-list 'load-path "~/.emacs.d/mepihlaj/yasnippet")
(require 'yasnippet)
(setq yas/snippet-dirs '("~/.emacs.d/mepihlaj/yasnippet/snippets"
                         "~/.emacs.d/mepihlaj/yasnippet/extras/imported"))

;; (yas/global-mode 1)

;; autopair for non-lisp parenthesis goodness
(require 'autopair)
(add-hook 'ruby-mode-common-hook #'(lambda () (autopair-mode)))
(add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
(add-hook 'coffeescript-mode-common-hook #'(lambda () (autopair-mode)))

(add-hook 'javascript-mode-hook (lambda () (autopair-mode +1)))
(add-hook 'javascript-mode-hook (lambda () (paredit-mode -1)))

;; auto-complete
;; http://sebastianlab.com/post/2409175090/autocomplete-in-clojure
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/mepihlaj//ac-dict")
(ac-config-default)

;; ac-slime
(add-to-list 'load-path "~/.emacs.d/mepihlaj/ac-slime")
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)

;; bm for buffer local bookmarks
;; https://github.com/joodland/bm
(add-to-list 'load-path "~/.emacs.d/mepihlaj/bm")
(require 'bm)
(autoload 'bm-toggle   "bm" "Toggle bookmark in current buffer." t)
(autoload 'bm-next     "bm" "Goto bookmark."                     t)
(autoload 'bm-previous "bm" "Goto previous bookmark."            t)

(global-set-key (kbd "<M-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)

;; align-cljlet
(add-to-list 'load-path "~/.emacs.d/mepihlaj/align-cljlet")
(require 'align-cljlet)

;; Clourescript development ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; cljs browser repl as inferior lisp
(setq inferior-lisp-program "lein repl")
(add-hook 'inferior-lisp-mode-hook (lambda () (paredit-mode +1)))

;;; cljs files
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

;; Allow input to be force sent to *inferior-lisp*
;; even if swank clojure is running
;; see https://github.com/brentonashworth/one/wiki/Emacs
;;
;; This is a total hack: we're hardcoding the name of the shell buffer
(defun inferior-lisp-send-input (input)
  "Send INPUT into the *shell* buffer and leave it visible."
  (save-selected-window
    (switch-to-buffer-other-window "*inferior-lisp*")
    (goto-char (point-max))
    (insert input)
    (comint-send-input)))

(defun defun-at-point ()
  "Return the text of the defun at point."
  (apply #'buffer-substring-no-properties
         (region-for-defun-at-point)))

(defun region-for-defun-at-point ()
  "Return the start and end position of defun at point."
  (save-excursion
    (save-match-data
      (end-of-defun)
      (let ((end (point)))
        (beginning-of-defun)
        (list (point) end)))))

(defun expression-preceding-point ()
  "Return the expression preceding point as a string."
  (buffer-substring-no-properties
   (save-excursion (backward-sexp) (point))
   (point)))

(defun shell-eval-last-expression ()
  "Send the expression preceding point to the *shell* buffer."
  (interactive)
  (inferior-lisp-send-input (expression-preceding-point)))

(defun shell-eval-defun ()
  "Send the current toplevel expression to the *shell* buffer."
  (interactive)
  (inferior-lisp-send-input (defun-at-point)))

(add-hook 'clojure-mode-hook
          '(lambda ()
             (define-key clojure-mode-map (kbd "C-c e") 'shell-eval-last-expression)
             (define-key clojure-mode-map (kbd "C-c x") 'shell-eval-defun)))
