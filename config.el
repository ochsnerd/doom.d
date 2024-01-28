;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "David Ochsner"
      user-mail-address "davidochsner93@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 13 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(use-package! org-roam
  :custom (org-roam-directory "~/org/roam")
  :config (org-roam-db-autosync-mode))

(setq org-plantuml-exec-mode 'plantuml)
(setq org-plantuml-executable-path "/usr/bin/plantuml")

(after! magit
  (setq magit-diff-hide-trailing-cr-characters t))

(after! auth-source
  (setq auth-sources '("~/.authinfo")))

;; outdated
(use-package! mfgpt
    :load-path "~/mfgpt")

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
(after! copilot
  (setq copilot-idle-delay 4))

(global-set-key [remap evil-quit] 'kill-buffer)

;; Presenting
;;
;; Load org-faces to make sure we can set appropriate faces
(require 'org-faces)

;; Resize Org headings
(dolist (face '((org-level-1 . 1.2)
               (org-level-2 . 1.1)
               (org-level-3 . 1.05)
               (org-level-4 . 1.0)
               (org-level-5 . 1.1)
               (org-level-6 . 1.1)
               (org-level-7 . 1.1)
               (org-level-8 . 1.1)))
 (set-face-attribute (car face) nil :font doom-variable-pitch-font :weight 'medium :height (cdr face)))

;; Make the document title a bit bigger
(set-face-attribute 'org-document-title nil :font doom-variable-pitch-font :weight 'bold :height 1.3)

;; Make sure certain org faces use the fixed-pitch face when variable-pitch-mode is on
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

(setq visual-fill-column-width 110
      visual-fill-column-center-text t)

(defun my-org-present-start ()
  ;; Adjust font sizes
  ;; (doom-big-font-mode 1)
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4) variable-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
                                     (org-code (:height 1.45) org-code)
                                     (org-verbatim (:height 1.45) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))

  (setq header-line-format " ")
  (org-display-inline-images)
  (setq org-hide-emphasis-markers t)
  ;; Center the presentation and wrap lines
  (visual-fill-column-mode 1)
  (visual-line-mode 1)
  (variable-pitch-mode 1))

(defun my-org-present-end()
  ;; Revert my-org-present-start
  ;; (doom-big-font-mode 0)
  ;; Doing it like this keeps the buffer in a variable-pitch font - I don't want that
  ;; (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq-local face-remapping-alist nil)
  (org-remove-inline-images)
  (setq org-hide-emphasis-markers nil)
  (setq header-line-format nil)
  (visual-fill-column-mode 0)
  (visual-line-mode 0)
  (variable-pitch-mode 0))

(add-hook 'org-present-mode-hook 'my-org-present-start)
(add-hook 'org-present-mode-quit-hook 'my-org-present-end)

;; Attach this to python-mode?
(defun my-black-buffer ()
  (interactive)
  (call-process-shell-command (concat "black" " " (buffer-file-name))))

(setq flycheck-checker-error-threshold 500)

;; Julia
(setq lsp-julia-command "/home/david/.julia/julia-1.9.4/bin/julia")

(after! lsp-julia
  (setq lsp-julia-default-environment "~/.julia/environments/v1.9"))

(after! lsp-julia
  (setq julia-repl-executable-records
      '((default "/home/david/.julia/julia-1.9.4/bin/julia")
        (LTS "/home/david/.julia/julia-1.9.4/bin/julia"))))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; ~config.el~:1 ends here
