;; Connect to SLIME from lein Clojure projects, launch repl
;; (defun slime-clojure ()
;;   (interactive)
;;   (require 'slime)
;;   (slime-setup '(slime-repl))
;;   (slime-connect "localhost" 4005))

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

;;; cljs browser repl as inferior lisp
(setq inferior-lisp-program "browser-repl")
(add-hook 'inferior-lisp-mode-hook (lambda () (paredit-mode +1)))

;;; cljs files
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(setq inferior-lisp-program "lein repl")

;; (set-variable 'inferior-lisp-buffer "*inferior-lisp*")
;; (set-variable 'inferior-lisp-program "/usr/bin/java -cp /Users/mepihlaj/Library/Clojure/lib/clojure.jar:/Users/mepihlaj/Library/Clojure/lib/clojure-contrib-1.2.0.jar clojure.main")
;; (menu-bar-mode t)
;; (server-start)

;;; Geiser scheme
(load-file "~/projects/scheme/geiser/elisp/geiser.el")
;; (add-hook 'geiser-racket-mode-hook (lambda () (paredit-mode +1)))
(setq geiser-active-implementations '(racket))

;;; set smaller font . OS X
(set-default-font "-apple-Monaco-medium-normal-normal-*-10-*-*-*-m-0-iso10646-1")

;;; undo-tree mode
(require 'undo-tree)
(global-undo-tree-mode)


;;; textmate mode https://github.com/tanoku/textmate.el
(require 'textmate)
(textmate-mode)
