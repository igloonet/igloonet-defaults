(with-eval-after-load 'tramp
  ;; use ssh by default
  (setq tramp-default-method "ssh")

  ;; use settings from ~/.ssh/config for ControlMaster
  (setq tramp-use-ssh-controlmaster-options
        nil)
  ;; complete sudo with ~/.ssh/known_hosts - using sudo only for remotes anyway
  (tramp-set-completion-function "sudo" tramp-completion-function-alist-ssh)
  ;; use /sudo:host:file to ssh and sudo to root user
  ;; simplify so we don't have to use long /ssh:....|sudo....

  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))

  ;; for local system, just use classic sudo
  (add-to-list 'tramp-default-proxies-alist
               '((regexp-quote (system-name)) nil
                 nil))

  (defun vlk/remote-file-edit (remote-server)
    (let* ((remote-file (buffer-file-name))
           (orig-path (s-split ":" remote-file))
           (file-path (-last-item orig-path))
           (new-remote-file (s-join ":"
                                    `("/sudo" ,remote-server ,file-path))))
      (split-window-horizontally)
      (switch-to-buffer (find-file new-remote-file))))
  (defun vlk/ivy-remote-file-edit ()
    (interactive)
    (ivy-read "Remote server: "
              ;; fce pro výběr serverů z known hosts :)
              (->> (tramp-parse-shosts "~/.ssh/known_hosts")
                   (-map '-second-item)
                   (-uniq)
                   (-drop 1))
              :action '(1
                        ("e"
                         (lambda (remote-server)
                           (vlk/remote-file-edit remote-server)
                           "Edit on other server")))))
  (defun vlk/open-remote-file ()
    (interactive)
    (ivy-read "Remote server: "
              ;; fce pro výběr serverů z known hosts :)
              (->> (tramp-parse-shosts "~/.ssh/known_hosts")
                   (-map '-second-item)
                   (-uniq)
                   (-drop 1))
              :action '(1
                        ("e"
                         (lambda (remote-server)
                           (let ((remote-file (s-join ":"
                                                      `("/sudo" ,remote-server "/"))))
                             (counsel-find-file remote-file)
                             "Edit on other server"))))))
  (spacemacs/declare-prefix "o" "remote-files-prefix")
  (spacemacs/set-leader-keys "of" 'vlk/open-remote-file
    "oe" 'vlk/ivy-remote-file-edit))

(provide 'igloonet-defaults-ssh)
