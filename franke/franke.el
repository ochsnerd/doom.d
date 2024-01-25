;;; franke.el --- Small franke-related functions -*- lexical-binding: t; -*-

;; Version 0.1

;;;###autoload
(defun franke-connect-to-panel (panel-name)
  (interactive "sName of the panel in .ssh/config: ")
  (let ((host-name (franke--host-to-hostname panel-name)))
    (if host-name
        (print (concat "Connecting to " host-name))
        (print (concat panel-name " not in .ssh/config")))))

(defun franke-hello ()
    (interactive)
    (print "Hello"))

(defun franke--host-to-hostname (host)
  (let ((host-name (franke--hostname-to-ip host)))
    (if (not (string-equal-ignore-case host host-name))
        host-name)))

(defun franke--hostname-from-ssh-config (host-name)
  (with-temp-buffer
    (insert (shell-command-to-string (concat "ssh -G " host-name)))
    (search-backward "\nhostname ")
    (forward-word 2)
    (franke--word-at-point)))


(defun franke--word-at-point ()
  "Modified word-at-point to correctly get the hostname from 'ssh -G whatever'"
  (let ((stab  (copy-syntax-table)))
    (with-syntax-table stab
      (modify-syntax-entry ?. "w")
      (thing-at-point 'word))))



