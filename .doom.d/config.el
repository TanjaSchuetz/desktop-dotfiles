;;; config.el -*- lexical-binding: t; -*-

;; Personal Data ####
(setq user-full-name "stira"
      user-mail-address "ralf.stich@infoniqa.com")

(setq auth-sources '("~/.authinfo.gpg")
      auth-source-cache-expiry nil) ; default is 7200 (2h)

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t            ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(delete-selection-mode 1)                         ; Replace selection when inserting text
(display-time-mode 1)                             ; Enable time in the mode-line
;; (unless (equal "Battery status not available"
;;                (battery))
;;   (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have
(global-subword-mode 1)                           ; Iterate through CamelCase words

(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))

(setq +ivy-buffer-preview t)

(map! :map evil-window-map
      "SPC" #'rotate-layout
       ;; Navigation
       "<left>"     #'evil-window-left
       "<down>"     #'evil-window-down
       "<up>"       #'evil-window-up
       "<right>"    #'evil-window-right
       ;; Swapping windows
       "C-<left>"       #'+evil/window-move-left
       "C-<down>"       #'+evil/window-move-down
       "C-<up>"         #'+evil/window-move-up
       "C-<right>"      #'+evil/window-move-right)

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)

(setq-default major-mode 'org-mode)

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 16)
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 24)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 18)
      doom-serif-font (font-spec :family "Iosevka Nerd Font" :weight 'light))

(setq doom-theme 'doom-nord)
(delq! t custom-theme-load-path)

(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq display-line-numbers-type t)
;; (setq display-line-numbers-type 'relative)

(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

(custom-set-faces! '(doom-modeline-evil-insert-state :weight bold :foreground "#339CDB"))

;; (setq neo-window-fixed-size nil)

(setq browse-url-browser-function 'firefox)

(map!
  (:after dired
    (:map dired-mode-map
     "C-x i" #'peep-dired
     )))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq-hook! prog-mode select-enable-clipboard t)

(map! :n [mouse-8] 'better-jumper-jump-backward
      :n [mouse-9] 'better-jumper-jump-forward)

(setq frame-title-format
    '(""
      (:eval
       (if (s-contains-p org-roam-directory (or buffer-file-name ""))
           (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
         "%b"))
      (:eval
       (let ((project-name (projectile-project-name)))
         (unless (string= "-" project-name)
           (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

;; -*- no-byte-compile: t; -*-

;; (package! rotate)

;; (package! xkcd)

;; (package! selectric-mode)

;;(package! wttrin :recipe (:local-repo "lisp" :no-byte-compile t))

;; (package! spray)

;; (package! theme-magic)

;; (package! flyspell-lazy :pin "3ebf68cc9e...")

;; (package! magit-delta :recipe (:host github :repo "dandavison/magit-delta") :pin "0c7d8b2359")

(use-package! vlf-setup
  :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)

(setq org-directory "~/Documents/org/")

(setq which-key-mode t)
(setq global-undo-tree-mode t)

(use-package! company
  :init
  (global-company-mode t)
  )
;;
;; number pad keys
;; <kp-decimal>
;; <kp-0>
;; <kp-1>
;; <kp-2>
;; <kp-3>
;; <kp-subtract>
;; <kp-divide>
;; <kp-multiply>

;;
;;Edits
;;
;; (define-key evil-visual-state-map (kbd "s-c") (kbd "\"+y"))
;; (define-key evil-insert-state-map  (kbd "s-v") (kbd "^R+"))
;; (define-key evil-ex-completion-map (kbd "s-v") (kbd "^R+"))
;; (define-key evil-ex-search-keymap  (kbd "s-v") (kbd "^R+"))

(global-set-key (kbd "C-S-v")    'undo-tree-visualize)
(global-set-key (kbd "C-S-z")    'undo-tree-undo)
(global-set-key (kbd "C-S-y")    'undo-tree-redo)

"delete"
(global-set-key (kbd "C-S-x")    'evil-delete)
(global-set-key (kbd "C-S-d")    'yank)

"comments"
(global-set-key (kbd "C-<kp-divide>") 'evilnc-comment-or-uncomment-lines)
(global-set-key (kbd "S-<kp-divide>") 'evilnc-comment-or-uncomment-paragraphs)

"Folding"
(global-set-key (kbd "C-S--")    'evil-close-folds)
(global-set-key (kbd "C--")      'evil-close-fold)
(global-set-key (kbd "C-S-+")    'evil-open-folds)
(global-set-key (kbd "C-+")      'evil-open-fold)

"indenting"
(global-set-key (kbd "M-<f8>")    'indent-region)
(global-set-key (kbd "C-<tab>")   'indent-relative)
(global-set-key (kbd "C-S-<tab>") 'indent-region)

"file operations"
(global-set-key (kbd "C-s")       'save-buffer)
(global-set-key (kbd "C-S-l")     'sort-lines)
(global-set-key (kbd "M-<down>")  'drag-stuff-down)
(global-set-key (kbd "M-<up>")    'drag-stuff-up)

"Konfigurations Management"
(global-set-key (kbd "C-S-r")     'doom/reload)

"Tools"
(global-set-key (kbd "<f3>")      'neotree-toggle)
(global-set-key (kbd "C-S-g")     'magit)

"Window Management"
(global-set-key (kbd "M-<left>")    'evil-window-prev)
(global-set-key (kbd "M-<right>")   'evil-window-next)
(global-set-key (kbd "M-S-<right>") 'next-buffer)
(global-set-key (kbd "M-S-<left>")  'previous-buffer)
(global-set-key (kbd "C-S-b")       'helm-buffers-list)

(custom-set-faces
 )
