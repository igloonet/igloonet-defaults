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


  ;; FIXME: přidat help
  ;; ** TRAMP
  ;;   Už dlouho chci používat emacs na editaci souborů vzdáleně, ale je to strašně krkolomné klasickou cestou. Kvůli tomu jsem napsal kus elispového kódu, který mi v tomto zjednodušuje život :)
  ;; Vytvořil jsem si dvě funkce pro vzdálenout editaci souborů na serverech.
  ;;
  ;; Jde o zjednodušení procesu vybírání souborů =(SPC o f)= :) Přes =ivy= vyberete server (parsuje se z known_hosts), a pak se přes =counsel= dohledávají soubory. To ovládání chce trošku zvyku:
  ;;
  ;; - / :: skočí do adresáře
  ;; - <TAB> :: doplní cestu jak to jde
  ;; - <ENTER> :: otevře adresář v Dired a nebo soubor v bufferu
  ;;
  ;; Druhá fce =(SPC o e)= otevře soubor se stejnou cestou na jiném serveru dle výberu v =ivy=.
  ;;
  ;; Pro otestovací stačí blok akorát spustit.
  (defun vlk/remote-file-edit (remote-server)
    (let* ((remote-file (buffer-file-name))
           (orig-path (s-split ":" remote-file))
           (file-path (-last-item orig-path))
           (new-remote-file (s-join ":" `("/sudo" ,remote-server ,file-path))))
      (split-window-horizontally)
      (switch-to-buffer (find-file new-remote-file))))


  (defun vlk/sudo-open-same-file-elsewhere ()
    (interactive)
    (ivy-read "Remote server: "
              ;; fce pro výběr serverů z known hosts :)
              (->> (tramp-parse-shosts "~/.ssh/known_hosts") (-map '-second-item) (-uniq) (-drop 1))
              :action '(1
                        ("e"  (lambda (remote-server)
                                (vlk/remote-file-edit remote-server) "Edit on other server")))))


  (defun vlk/sudo-open-remote-file ()
    (interactive)
    (ivy-read "Remote server: "
              ;; fce pro výběr serverů z known hosts :)
              (->> (tramp-parse-shosts "~/.ssh/known_hosts") (-map '-second-item) (-uniq) (-drop 1))
              :action '(1
                        ("e"  (lambda (remote-server)
                                (let ((remote-file (s-join ":" `("/sudo" ,remote-server "/"))))
                                  (counsel-find-file remote-file) "Edit on other server"))))))

  (defun kepi/open-remote-file ()
    (interactive)
    (ivy-read "Remote server: "
              ;; fce pro výběr serverů z known hosts :)
              (->> (tramp-parse-shosts "~/.ssh/known_hosts") (-map '-second-item) (-uniq) (-drop 1))
              :action '(1
                        ("e"  (lambda (remote-server)
                                (let ((remote-file (s-join ":" `("/ssh" ,remote-server "/"))))
                                  (counsel-find-file remote-file) "Edit on other server")))))))

(spacemacs/declare-prefix "I" "igloonet")
(spacemacs/declare-prefix "If" "files")
(spacemacs/set-leader-keys
  "Iff" 'kepi/open-remote-file
  "Ifs" 'vlk/sudo-open-remote-file
  "Ife" 'vlk/sudo-open-same-file-elsewhere)

(provide 'igloonet-defaults-ssh)
