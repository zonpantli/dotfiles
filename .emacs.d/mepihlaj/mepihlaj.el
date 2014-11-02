;;== cider mode setup ===========================================
(setq cider-popup-stacktraces nil)
(add-hook 'cider-repl-mode-hook
          (lambda () (paredit-mode 1)))

(setq nrepl-hide-special-buffers t)

;;== ac-nrepl ====================================================
;(require 'ac-nrepl)
;(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
;(add-hook 'cider-mode-hook 'ac-nrepl-setup)
;(eval-after-load "auto-complete"
  ;'(add-to-list 'ac-modes 'cider-repl-mode))


;;== Set Cmd as Meta key =========================================
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;;== set smaller font . OS X =====================================
(set-default-font "-apple-Monaco-medium-normal-normal-*-11-*-*-*-m-0-iso10646-1")

;;== set initial frame size  =====================================
(if (window-system)
    (set-frame-size (selected-frame) 110 60))


;;== align-cljlet ===============================================
(add-to-list 'load-path "~/.emacs.d/mepihlaj/align-cljlet")
(require 'align-cljlet)

;;== Geiser scheme ================================================
(load-file "~/.emacs.d/mepihlaj/geiser/elisp/geiser.el")
(add-hook 'geiser-racket-mode-hook (lambda () (paredit-mode +1)))
(setq geiser-active-implementations '(racket))
(setq geiser-guile-binary "/usr/local/bin/guile")
(setq geiser-racket-binary "/Applications/Racket v5.2.1/bin/racket")


;;== undo-tree mode ===============================================
(require 'undo-tree)
(global-undo-tree-mode)

;;== textmate mode https://github.com/tanoku/textmate.el ==========
(require 'textmate)
(textmate-mode)

;;== autopair for non-lisp parenthesis goodness ===================
(require 'autopair)
(add-hook 'ruby-mode-hook (lambda () (autopair-mode)))
(add-hook 'c-mode-hook (lambda () (autopair-mode)))
(add-hook 'coffee-mode-hook (lambda () (autopair-mode)))
(add-hook 'html-mode-hook (lambda () (autopair-mode)))
(add-hook 'scss-mode-hook (lambda () (autopair-mode)))
(add-hook 'io-mode-hook (lambda () (autopair-mode)))

;;== auto-complete ==================================================
;; http://sebastianlab.com/post/2409175090/autocomplete-in-clojure
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/mepihlaj/ac-dict")
(ac-config-default)


;;== bm for buffer local bookmarks ===================================
;; https://github.com/joodland/bm
(add-to-list 'load-path "~/.emacs.d/mepihlaj/bm")
(require 'bm)
(autoload 'bm-toggle   "bm" "Toggle bookmark in current buffer." t)
(autoload 'bm-next     "bm" "Goto bookmark."                     t)
(autoload 'bm-previous "bm" "Goto previous bookmark."            t)

(global-set-key (kbd "<M-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)

;;== Clourescript ==================================================
;;; cljs browser repl as inferior lisp

; inferior lisp setup for one-style project, just start lein repl
(setq inferior-lisp-program "lein repl")

; using cljsbuild, start repl at localhost:9000 (see noir-cljs) 
(defun clojurescript-repl ()
 (interactive)
 (run-lisp "lein trampoline cljsbuild repl-listen"))

(add-hook 'inferior-lisp-mode-hook (lambda () (paredit-mode +1)))

;;; cljs files
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

;; Allow input to be force sent to *inferior-lisp*
;; even if swank clojure is running
;; see https://github.com/brentonashworth/one/wiki/Emacs
;;
;; This is a total hack: we're hardcoding the name of the *inferior-lisp* buffer
(defun inferior-lisp-send-input (input)
  "Send INPUT into the *inferior-lisp* buffer and leave it visible."
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

;;== scss mode ===================================================
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq scss-compile-at-save nil)
(setq css-indent-level 2)
(setq css-indent-offset 2)

;;== js2-mode ===================================================
(autoload 'js2-mode "js2-mode/js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;== org-mode setup =============================================
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;== org-mode babel Clojure(require 'ob) ========================
(require 'org-install)
(require 'ob-tangle)
(add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

(defvar org-babel-default-header-args:clojure 
  '((:results . "silent") (:tangle . "yes")))

(defun org-babel-execute:clojure (body params)
  "Evaluate a block of Clojure code with Babel."
  (lisp-eval-string body)
  "Done!")

(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-src-window-setup 'current-window)

(provide 'ob-clojure)

;;== io inferior mode ==========================================
(add-to-list 'load-path "~/.emacs.d/mepihlaj/io-emacs")
(require 'io-mode-inf)

;;== ido customizations ========================================
;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)

;;== evil ======================================================
(add-hook 'after-init-hook
          (lambda ()
            (add-to-list 'load-path "~/.emacs.d/mepihlaj/evil")
            (add-to-list 'load-path "~/.emacs.d/mepihlaj/evil-surround")
            (require 'evil)
            (require 'surround)
            (global-surround-mode 1)
            (add-hook 'clojure-mode-hook
                      '(lambda () (evil-local-mode 1)))
            (add-hook 'clojure-mode-hook
                      '(lambda () (setq evil-shift-width 2)))
            (add-hook 'sml-mode-hook
                      '(lambda () (evil-local-mode 1)))
            (add-hook 'emacs-lisp-mode-hook
                      '(lambda () (evil-local-mode 1)))

            ;; Overload shifts so that they don't lose the selection
            ;; http://superuser.com/questions/684540/evil-mode-evil-shift-left-loses-selection
            (define-key evil-visual-state-map (kbd ">") 'djoyner/evil-shift-right-visual)
            (define-key evil-visual-state-map (kbd "<") 'djoyner/evil-shift-left-visual)
            (define-key evil-visual-state-map (kbd "M-]") 'djoyner/evil-shift-right-visual)
            (define-key evil-visual-state-map (kbd "M-[") 'djoyner/evil-shift-left-visual)

            (defun djoyner/evil-shift-left-visual ()
              (interactive)
              (evil-shift-left (region-beginning) (region-end))
              (evil-normal-state)
              (evil-visual-restore))

            (defun djoyner/evil-shift-right-visual ()
              (interactive)
              (evil-shift-right (region-beginning) (region-end))
              (evil-normal-state)
              (evil-visual-restore))

            ;; For an OS X user, CMD-V pastes in insert mode
            (define-key evil-insert-state-map (kbd "M-v") 'evil-paste-after)

            ;; Like in MacVim
            (define-key evil-visual-state-map (kbd "M-/") 'comment-dwim)
))




;;== project local varables ====================================
(require 'project-local-variables)

;;== global autorevert to make switching branches nice =========
(global-auto-revert-mode 1)

;;== set file shortcuts to registers ===========================
(set-register ?e '(file . "~/.emacs.d/mepihlaj/mepihlaj.el"))

