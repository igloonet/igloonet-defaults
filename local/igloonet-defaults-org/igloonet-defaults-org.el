(with-eval-after-load 'org
  ;; todo keywords sequences
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "INPROG(i)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

  ;; triggers to automatically sets and remove tags as task state is changing
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("INPROG" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  ;; colors for todo keywords
  ;; http://raebear.net/comp/emacscolors.html
  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "green" :weight bold)
                ("INPROG" :foreground "deep sky blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold :strike-through t)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold))))


    ;; babel block settings
    (setq org-edit-src-content-indentation 0
          org-src-tab-acts-natively t
          org-src-fontify-natively t
          org-confirm-babel-evaluate nil)

    ;; various org settings
    (setq org-startup-with-inline-images t
          org-agenda-sticky t
          org-startup-indented t
          org-use-fast-todo-selection t
          org-treat-S-cursor-todo-selection-as-state-change nil
          org-ctrl-k-protect-subtree t
          org-drawers (quote ("PROPERTIES""LOGBOOK"))
          org-log-into-drawer t
          org-log-done 'time
          org-agenda-span 'day)

    ;; add a org-attach att abbrev to links
    (require 'org-attach)
    (push '("att" . org-attach-expand-link) org-link-abbrev-alist)

    ;; evil surround - support for s and S to add source block
    (require 'evil-surround)
    (add-hook 'org-mode-hook (lambda()
                               (push '(?s . ("#+BEGIN_SRC" . "#+END_SRC")) evil-surround-pairs-alist)
                               )))

;; namísto odrážek v orgu nastavíme pěkný bullets
;; zdroj: http://www.howardism.org/Technical/Emacs/orgmode-wordprocessor.html
(font-lock-add-keywords 'org-mode
                        '(("^\s*\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(provide 'igloonet-defaults-org)
