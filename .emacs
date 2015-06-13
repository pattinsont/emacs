;;Package.el customization
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; install packages
(defvar my-packages '(
		      auto-complete
		      paredit
		      rainbow-delimiters
		      markdown-mode
		      solarized-theme
		      ))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-refresh-contents)
    (package-install p)))

;; The following line can be removed after first install to speed up startup
(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)
(setq default-directory "~/" ) 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(backup-inhibited t t)
 '(cursor-type 'bar t)
 '(column-number-mode t)
 '(delete-selection-mode t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(tool-bar-mode nil)
 '(xterm-mouse-mode 1))

;; paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))

;; Auto complete
(require 'auto-complete-config)
(ac-config-default)
(define-key ac-completing-map "\M-/" 'ac-stop)

;; rainbow delimiters
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;; slime
(setq inferior-lisp-program "sbcl") ; your Lisp system
(add-to-list 'load-path "~/hacking/lisp/slime/")  ; your SLIME directory
(require 'slime-autoloads)
(slime-setup '(slime-fancy)) ; almost everything
;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil)
  (define-key slime-repl-mode-map 
    (kbd "M-r") 'paredit-raise-sexp))
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (visual-line-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")

(load-theme 'solarized-dark t)
