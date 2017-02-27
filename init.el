(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(starter-kit
    starter-kit-bindings
    starter-kit-lisp
    org
    org-jira
    ;; Clojure & friends
    clojure-mode
    clojure-snippets
    cider
    align-cljlet
    clj-refactor
    cider-eval-sexp-fu
    ;; Lisps
    rainbow-delimiters
    paxedit
    ;; Completion popup
    company
    popup
    ;; Project navigation
    projectile
    ack-and-a-half
    ;; Misc.
    terraform-mode
    json-mode
    yaml-mode
    sass-mode
    markdown-mode
    color-theme-sanityinc-tomorrow
    powerline
    yasnippet
    buffer-move
    color-identifiers-mode
    highlight
    git-link
    expand-region
    avy
    twittering-mode)
  "A list of packages to ensure are installed at launch.")

;; Automaticaly install any missing packages
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Load key bindings.
(load (concat user-emacs-directory "keybinds.el"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:weight bold :foreground "#cc0000"))))
 '(idle-highlight ((t (:inherit region :background "maroon4")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#c5c8c6" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#373b41"))
 '(auto-save-default nil)
 '(backup-inhibited t t)
 '(blink-matching-paren nil)
 '(cider-buffer-name-show-port t)
 '(cljr-favor-prefix-notation nil)
 '(cljr-favor-private-functions nil)
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" default)))
 '(delete-selection-mode t)
 '(fci-rule-color "#373b41")
 '(git-link-open-in-browser t t)
 '(magit-emacsclient-executable "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient")
 '(nrepl-host "localhost")
 '(org-agenda-files (quote ("~/Code/epam/org/main.org")))
 '(package-selected-packages
   (quote
    (org-jira yaml-mode twittering-mode swiper starter-kit-lisp starter-kit-bindings sass-mode rainbow-delimiters projectile powerline popup paxedit markdown-mode mac-key-mode json-mode git-link expand-region company color-theme-sanityinc-tomorrow color-identifiers-mode clojure-snippets clj-refactor cider-eval-sexp-fu buffer-move avy align-cljlet ack-and-a-half)))
 '(projectile-use-git-grep t)
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#cc6666")
     (40 . "#de935f")
     (60 . "#f0c674")
     (80 . "#b5bd68")
     (100 . "#8abeb7")
     (120 . "#81a2be")
     (140 . "#b294bb")
     (160 . "#cc6666")
     (180 . "#de935f")
     (200 . "#f0c674")
     (220 . "#b5bd68")
     (240 . "#8abeb7")
     (260 . "#81a2be")
     (280 . "#b294bb")
     (300 . "#cc6666")
     (320 . "#de935f")
     (340 . "#f0c674")
     (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil))

(split-window-right)

(menu-bar-mode t)

(yas-global-mode 1)

(global-company-mode)
(global-color-identifiers-mode)
(global-whitespace-mode)

(add-hook 'prog-mode-hook 'hs-minor-mode)

(add-hook 'clojure-mode-hook
          (lambda ()
            (clj-refactor-mode 1)
            (paxedit-mode)
            (cljr-add-keybindings-with-prefix "s-r")))

;; Add an extra newline to separate commit message from git commentary

(defun magit-commit-mode-init ()
  (when (looking-at "\n")
    (open-line 1)))

(add-hook 'git-commit-mode-hook 'magit-commit-mode-init)

(setq-default whitespace-line-column 90)

(require 'cider)
(setq cider-known-endpoints '(("localhost" "7888")))

(defun cleanup-buffer ()
  (interactive)
  (whitespace-cleanup)
  (untabify (point-min) (point-max))
  ;;  (indent-region (point-min) (point-max))
  )

(add-hook 'before-save-hook 'cleanup-buffer)

(eval-when-compile (require 'cl-lib))

(add-hook 'focus-out-hook
          (lambda ()
            (cl-letf (((symbol-function 'message) #'format))
              (save-some-buffers t))))

;;; Turn on expression highlighting

(show-paren-mode 1)
(setq-default blink-matching-paren nil
              show-paren-style 'parenthesis
              show-paren-delay 0)

(require 'cl)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  (flet ((process-list ())) ad-do-it))

(define-clojure-indent
  ;; om & om-tools indenting
  (display-name 'defun)
  (init-state 'defun)
  (will-mount 'defun)
  (did-mount 'defun)
  (will-unmount 'defun)
  (render 'defun)
  (render-state 'defun)
  (should-update 'defun)
  (will-update 'defun)
  (will-receive-props 'defun)
  (did-update 'defun)
  ;; prismatic plumbing
  (for-map 'defun)
  (letk 'defun)
  (fnk 'defun)
  ;; compojure
  (context 'defun)
  ;;
  (let-programs 'defun)
  ;; component
  (start 'defun)
  (stop 'defun)
  (init 'defun)
  (db 'defun)
  (conn 'defun)
  ;; datalog
  (and-join 'defun)
  (or-join 'defun)
  (not-join 'defun)
  )

(font-lock-add-keywords
 nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|HACK\\|REFACTOR\\|NOCOMMIT\\)"
        1 font-lock-warning-face t)))

;; General
(setq initial-scratch-message nil)
(when (locate-library "clojure-mode")
  (setq initial-major-mode 'clojure-mode))

(projectile-global-mode)
(setq projectile-show-paths-function 'projectile-hashify-with-relative-paths)

;; Visual
(set-default-font "Input Mono Condensed 14")
(load-theme 'sanityinc-tomorrow-night t)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

(global-linum-mode t)
(setq linum-format "%3d ")

(setq-default tab-width 2)
(fset 'yes-or-no-p 'y-or-n-p)

(setq visible-bell nil)
(setq ring-bell-function #'ignore)

(require 'powerline)
(powerline-center-theme)

;; Clojure
(setq auto-mode-alist (cons '("\\.boot$" . clojure-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hiccup$" . clojure-mode) auto-mode-alist))

(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)

(add-to-list 'same-window-buffer-names "*cider")

(setq nrepl-buffer-name-show-port t)
(setq cider-prompt-save-file-on-load nil)

(require 'cider-eval-sexp-fu)

;; Ido-mode customizations
(setq ido-decorations
      (quote
       ("\n-> "           ; Opening bracket around prospect list
        ""                ; Closing bracket around prospect list
        "\n   "           ; separator between prospects
        "\n   ..."        ; appears at end of truncated list of prospects
        "["               ; opening bracket around common match string
        "]"               ; closing bracket around common match string
        " [No match]"     ; displayed when there is no match
        " [Matched]"      ; displayed if there is a single match
        " [Not readable]" ; current diretory is not readable
        " [Too big]"      ; directory too big
        " [Confirm]")))   ; confirm creation of new file or buffer

(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-completion-map [down] 'ido-next-match)
            (define-key ido-completion-map [up] 'ido-prev-match)
            (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
            (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)))

(add-hook 'focus-out-hook
          (lambda ()
            (cl-letf (((symbol-function 'message) #'format))
              (save-some-buffers t))))


(put 'erase-buffer 'disabled nil)
(put 'scroll-left 'disabled nil)

                                        ; Jira integration

(setq jiralib-url "https://jiraeu.epam.com")
