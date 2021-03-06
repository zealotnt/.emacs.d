(require 'package)

;========================================================
; SETUP PACKAGES
;========================================================
(setq my-saved-launch-directory default-directory)
;; set the dir where all elpa packages go
(setq relative-config-dir "~/.emacs.d/")
(setq package-user-dir (concat relative-config-dir "welpa"))

; List the packages you want
(setq package-list '(
                      ;========================================================
                      ; Package: GENERAL
                      ;========================================================
                      evil ;Vi mode
                      general ;evil leader map
                      bind-map ;keymap available across different “leader keys”
                      which-key ;key leader guide
                      async ;asynchronous processing in Emacs
                      use-package ;package manager
                      exec-path-from-shell
                      ;========================================================
                      ; Package: Search
                      ;========================================================
                      helm-ag
                      helm-projectile
                      neotree ;Tree explorer
                      find-file-in-project ;neotree project path support
                      ;========================================================
                      ; Package: UI
                      ;========================================================
                      autothemer ;theme
                      spaceline ;Bottom statusline
                      indent-guide ;indent guide
                      highlight-parentheses; UI: highlight
                      ;========================================================
                      ; Package: GIT
                      ;========================================================
                      magit ;git tools
                      forge
                      magit-popup ;git tools
                      evil-magit ;git tools with vi mode
                      git-gutter ;indicating inserted, modified or deleted lines
                      git-link ;copy github link
                      git-timemachine ;git tools
                      ;========================================================
                      ; Package: Edit tools
                      ;========================================================
                      flycheck ;syntax error checking
                      auto-complete
                      evil-nerd-commenter ;comment code
                      evil-surround ;surroundings: parentheses, brackets, quotes, XML tags, and more
                      evil-leader
                      avy ;jumping to visible text using a char-based decision tree
                      evil-mc
                      ;========================================================
                      ; Package: Ruby tools
                      ;========================================================
                      haml-mode ;Haml for ruby development
                      ruby-test-mode ; ruby development
                      rbenv ; ruby env
                      inf-ruby ; ruby irb
                      ;========================================================
                      ; Package: JS tools
                      ;========================================================
                      add-node-modules-path
                      ;========================================================
                      ; Package: Workspace tools
                      ;========================================================
                      persp-mode ;perspectives for emacs, save/recover sessions
                      osx-clipboard
                      org
                      ;========================================================
                      ; Package: Uncategorized - Mine recently added
                      ;========================================================
                      anzu
                      yaml-mode
                      evil-visualstar
                      tmux-pane
                      vimrc-mode
                      web-mode
                      helm-ext
                      json-mode
                      go-mode
                      highlight-indent-guides
                      winum
                      go-autocomplete
                      evil-collection
                      pdf-tools
                      go-imenu
                      helm-describe-modes
                      helm-xref
                      daemons
                      evil-anzu
                      auto-dim-other-buffers
                      lua-mode
                      arduino-mode
                      kubernetes-evil
                      kubernetes
                      jsonnet-mode
                      terraform-mode
                      helm-descbinds
                      restclient
                      restclient-helm
                      ob-restclient
                      all-the-icons-dired
                      dired-narrow
                      evil-paredit
                      vlf
                      shackle
                      php-mode
                      dockerfile-mode
                      origami
                      imenu-list
                      indent-tools
                      protobuf-mode
                      atomic-chrome
                      gitignore-mode
                      image+
                      dash-functional
                      cmake-mode
                      rust-mode
                      ))

; Add Melpa as the default Emacs Package repository
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

; Activate all the packages (in particular autoloads)
(package-initialize)

;Init file paths
(defun w/dotfiles-folder-path ()
  (let ((path1 (replace-regexp-in-string  "\n\+$" "" (shell-command-to-string "dirname $(readlink ~/.emacs.d/init.el) 2>/dev/null"))))
    (if (not(string= "" path1))
      path1
      (replace-regexp-in-string  "\n\+$" "" (shell-command-to-string "readlink ~/.emacs.d 2>/dev/null"))
      )
    )
  )
(setq w-dotfiles-folder-path (w/dotfiles-folder-path))
(setq w-dotfiles-pakages-folder-path (format "%s/packages" w-dotfiles-folder-path))
(setq evil-evilified-state-path (format "%s/packages/evil-evilified-state.el" w-dotfiles-folder-path))

;; This is only needed once, near the top of the file
(eval-when-compile
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path (format "%s/packages" w-dotfiles-folder-path))
  (require 'use-package))

; Update your local package index
(unless package-archive-contents
  (package-refresh-contents))

; Install all missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; load packages in this local repository
(setq z/initial-load-files
      (vector
       "yaml-imenu/yaml-imenu.el"
       "go-imenu/go-imenu.el"
       "xclip.el"
       "navigate.el"
       "justify-kp.el"
       "so-long.el"
       "figlet.el"
       "eval-pulse.el"
       ))
(mapcar
 (lambda (x)
   (message x)
   (load (format "%s/packages/%s" w-dotfiles-folder-path x)))
 z/initial-load-files)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (format "%s/packages/tty-format.el" w-dotfiles-folder-path))

(require 'tty-format)
(defun z/display-ansi-colors ()
  "https://stackoverflow.com/a/37193279"
  (interactive)
  (format-decode-buffer 'ansi-colors))

;; decode ANSI color escape sequences for *.txt or README files
;; (add-hook 'find-file-hooks 'tty-format-guess)
;; decode ANSI color escape sequences for .log files
(add-to-list 'auto-mode-alist '("\\.log\\'" . display-ansi-colors))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(xclip-mode 1)
(require 'navigate)
(setq use-package-verbose 't) ;Show use-package stat

;========================================================
; MAIN CONFIGS
;========================================================
(if (or (not (boundp 'w/is-running-an-async-job)) (not w/is-running-an-async-job))
    (progn
      (require 'org)
      (org-babel-load-file
       (expand-file-name "emacs.org"
                         w-dotfiles-folder-path))
      ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(blink-cursor-mode nil)
 '(git-gutter:added-sign "+")
 '(git-gutter:deleted-sign "-")
 '(git-gutter:modified-sign "*")
 '(global-display-line-numbers-mode t)
 '(initial-buffer-choice "~/.emacs.d/init.el")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (devdocs ts company-restclient dired-sidebar dired-imenu slime nov request systemd helm-systemd php-mode golden-ratio terraform-doc company-terraform discover-my-major kubernetes-evil kubernetes imenu-anywhere typescript-mode solarized-theme vala-mode helm-ext json-mode go-mode highlight-indent-guides reason-mode rjsx-mode smartparens import-js prettier-js js2-mode evil-leader evil which-key helm-ag helm-projectile autothemer)))
 '(tool-bar-mode nil))

;; customize monokai theme color
;; https://github.com/oneKelvinSmith/monokai-emacs#customization
(setq ;; foreground and background
      monokai-foreground     "#F8F8F2"
      monokai-background     "gray10"
      monokai-gray           "gray19")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil
                :overline nil :underline nil :slant normal :weight normal :width normal :foundry "PfEd"
                :family "DejaVu Sans Mono" :height 95))))
 '(auto-dim-other-buffers-face ((t (:background "gray19"))))
 '(cursor ((t (:background "gold" :foreground "#151718"))))
 '(mode-line ((t (:background "black" :foreground "#4499FF" :height 80))))
 '(mode-line-buffer-id ((t (:background "black" :foreground "#4499FF" :height 80))))
 '(mode-line-emphasis ((t (:background "black" :foreground "#4499FF" :height 80))))
 '(mode-line-highlight ((t (:background "black" :foreground "#4499FF" :height 80))))
 '(mode-line-inactive ((t (:background "black" :foreground "#4499FF" :height 80))))
 )

(server-start)
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "")
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; disable auto line breaking, more info: search auto-fill-mode

(setq z/initial-open-files
      (vector
       "~/dotfiles/.zshrc"
       "~/dotfiles/.tmux.conf.local"
       "~/dotfiles/.bashrc-func"
       "~/.emacs.d/init.el"
       "~/notes.md"
       "~/.ssh/config"
       "~/.zprofile"
       "~/Dropbox/Book-Document/Books/"
       "~/dotfiles/dconf/dconf.dump.conf"
       "~/dotfiles/fresh_install.sh"
       "~/dotfiles/install_dotfiles_w_deps.sh"
       ))
(add-hook 'after-init-hook (lambda() (mapcar
                            (lambda (x)
                              (find-file x))
                            z/initial-open-files)) t)

(defalias 'insert-named-kbd-macro 'insert-kbd-macro)
(fset 'mtm-b64-decode [escape ?v ?i ?w ?\s-k ?\s-d ?6])
