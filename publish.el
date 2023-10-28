;;; publish.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Jacob Hilker
;;
;; Author: Jacob Hilker <jacob.hilker2@gmail.com>
;; Maintainer: Jacob Hilker <jacob.hilker2@gmail.com>
;; Created: September 15, 2022
;; Modified: September 15, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/jhilker/publish
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(setq user-emacs-directory "./.emacs")
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

(use-package straight
  :custom (straight-use-package-by-default t))
(use-package ox-hugo)

(setq org-link-abbrev-alist '(("github" . "https://github.com/%s")))
(dolist (org-file '("readme.org" "config.org" "home/devel/config/doom/config.org"))
  (with-current-buffer (find-file-noselect org-file)
    (message "exporting %s" org-file)
    (org-hugo-export-wim-to-md :all-subtrees)))



(provide 'publish)



;;; publish.el ends here
