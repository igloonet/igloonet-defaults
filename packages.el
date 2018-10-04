(setq igloonet-defaults-packages
      '(
        (igloonet-defaults-org :location local :toggle igloonet-defaults-for-org)
        (igloonet-defaults-ssh :location local :toggle igloonet-defaults-for-ssh)
        ))

(defun igloonet-defaults/init-igloonet-defaults-org ()
  (use-package igloonet-defaults-org))

(defun igloonet-defaults/init-igloonet-defaults-ssh ()
  (use-package igloonet-defaults-ssh))
