(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;(require 'doom-themes)

;; Global settings (defaults)
;;(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
;(load-theme 'doom-one t)
;; Enable flashing mode-line on errors
;;(doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
;(doom-themes-neotree-config)
;; or for treemacs users
;;(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
;(doom-themes-org-config)

;; no tool bar
(tool-bar-mode 0)

;; no scroll bars
(scroll-bar-mode -1)

;; no start up message
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; removes *messages* from the buffer
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer
(add-hook 'minibuffer-exit-hook
	  '(lambda ()
	     (let ((buffer "*Completions*"))
	       (and (get-buffer buffer)
		    (kill-buffer buffer)))))

;; no audible or visual bell when emacs is mad
(setq ring-bell-function 'ignore)

;; font size
(set-face-attribute 'default nil :height 100)

;; turn on line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; default frame size
(add-to-list 'default-frame-alist '(width . 90)
	     '(height . 100))

;; quick toggle fullscreen to match MacOS (Command + Control + f)
(global-set-key (kbd "M-C-f") 'toggle-frame-fullscreen)

(load-theme 'spacemacs-dark t)

;; use the tab key to make 4 spaces
(setq tab-width 4)
(setq indent-tabs-mode nil)

;; no backup~ files
(setq make-backup-files nil)

;; no #autosave# files
(setq auto-save-default nil)

;; allow upcase (C-x C-u) and downcase (C-x C-l) region
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
; Cycle candidates with C-n and C-p
(setq ac-use-menu-map t)

;; jump to other frame (split screen)
(global-set-key [C-tab] 'ace-window)
;; Disable right alt so we can type brackets
(setq mac-right-option-modifier nil)

;; Mac option and command keys to meta (helps with non-Mac external keyboard)
(setq mac-option-key-is-meta t
      mac-command-key-is-meta t
      mac-command-modifier 'meta)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit company-lsp pos-tip company eglot treemacs lsp-dart lsp-mode dart-mode neotree doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path "c:/Users/Nils-/OneDrive/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-vc-integration nil)

;; All the icons for neotree icons
(require 'all-the-icons)

;; Enable Company Mode in all buffers
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 1)

(setq dart-format-on-save t)
(setq dart-sdk-path  "C:/Users/Nils-/OneDrive/Skrivebord/flutter/flutter/bin/cache/dart-sdk/")
(setq exec-path (append exec-path '("C:/Program Files (x86)/GnuWin32/bin")))


;; Assist project.el in finding the project root for your dart fike
(defun project-try-dart (dir)
  (let ((project (or (locate-dominating-file dir "pubspec.yaml")
                     (locate-dominating-file dir "BUILD"))))
    (if project
        (cons 'dart project)
      (cons 'transient dir))))
(add-hook 'project-find-functions #'project-try-dart)
(cl-defmethod project-roots ((project (head dart)))
  (list (cdr project)))



;;dart eglot
(require 'eglot)
(add-to-list 'eglot-server-programs '(dart-mode . ("dart_language_server")))
(add-hook 'dart-mode-hook 'eglot-ensure)




(add-hook 'dart-mode-hook (lambda ()
 (set (make-local-variable 'company-backends)
      '(company-dart (company-dabbrev company-yankpad)))))
;(require 'company-lsp)
;(push 'company-lsp company-backends)

(elpy-enable)
 (setq python-shell-interpreter "ipython"
   python-shell-interpreter-args "-i --simple-prompt")

  ;; use flycheck not flymake with elpy
 (when (require 'flycheck nil t)
 (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
 (add-hook 'elpy-mode-hook 'flycheck-mode))



(global-set-key (kbd "C-x g") 'magit-status)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (emacs-lisp . t)
   (org . t)
   (shell . t)
   (C . t)
   (python . t)
   (gnuplot . t)
   (octave . t)
   (R . t)
   (dot . t)
   (awk . t)
   ))

(add-to-list 'org-structure-template-alist
         '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC" ""))

(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(defalias 'lsp--cur-line-diagnotics 'lsp--cur-line-diagnostics)


