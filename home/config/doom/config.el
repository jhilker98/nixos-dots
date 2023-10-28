(after! hydra-posframe
  (hydra-posframe-mode t))

(after! lsp-tailwindcss
  (setq lsp-tailwindcss-add-on-mode t))

(setq user-full-name "Jacob Hilker"
      user-mail-address "jacob.hilker2@gmail.com")

(when (featurep! emoji)
	(emojify-download-emoji))

(when (and (eq system-type 'gnu/linux)
           (string-match
            "Linux.*Microsoft.*Linux"
            (shell-command-to-string "uname -a")))
  (setq
   browse-url-generic-program  "/mnt/c/Windows/System32/cmd.exe"
   browse-url-generic-args     '("/c" "start")
   browse-url-browser-function #'browse-url-generic))

(defun copy-selected-text (start end)
  (interactive "r")
  (if (use-region-p)
      (let((text (buffer-substring-no-properties start end)))
        (shell-command (concat "echo '" text "' | clip.exe")))))

(setq doom-theme 'doom-gruvbox
      ;; doom-theme 'doom-nord ;; 20242C
      doom-font (font-spec :name "Josevka" :size 18)
      doom-unicode-font (font-spec :name "Josevka")
      doom-variable-pitch-font (font-spec :name "Josevka Book Sans" :size 18))

(set-face-attribute 'default nil :background "#1d2021") ;; Gruvbox Dark Hard

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic))

;(after! ielm
;  (set-popup-rule! "*ielm*" :side 'right :size 0.4))
;
;(after! helpful
;  (set-popup-rule! "*helpful\:\* *" :side 'right :size 0.4))

;(setq +popup-defaults
;  (list :side   'right
;;        ;:height 0.16
;        :width  0.5
;        :quit   t
;        :select #'ignore
;        :ttl    5))

(after! hydra-posframe
  (hydra-posframe-mode t))

(setq org-directory "~/Dropbox/org")

(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)" "CANC(c)"))
        org-todo-keyword-faces '(("TODO" . (:foreground "#fb4934" :underline t))
                                 ("NEXT" . (:foreground "#fe8019")))
        org-agenda-files '("gtd/inbox.org" "gtd/orgzly.org" "gtd/todo.org" "gtd/gcal.org")

        org-agenda-start-day nil ;; today
        org-ellipsis "▾"))

(defun jh/org-ui-hook ()
  (variable-pitch-mode 1)
  ;(setq display-line-numbers-type 'nil)
  (setq display-line-numbers nil)
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-document-title nil :font (font-spec :family "Josevka Book Slab" :size 22) :weight 'bold))

(add-hook! 'org-mode-hook #'jh/org-ui-hook)

(after! org-agenda
  (org-super-agenda-mode))
(after! org-recur
  (add-hook! 'org-mode-hook #'org-recur-mode)
  (add-hook! 'org-agenda-mode-hook #'org-recur-agenda-mode))

(use-package! org-habit
  :after org
  :config
  (setq org-habit-following-days 7
        org-habit-preceding-days 35
        org-habit-show-habits t))

(after! doct
  (setq org-capture-templates
            (doct '(("Inbox" :keys "i"
                     :file "~/Dropbox/org/gtd/inbox.org"
                     :template "* TODO %^{TODO Item}"
                     :immediate-finish t)))))

(after! (:and doct org-chef)
  (setq org-capture-templates
        (doct-add-to org-capture-templates
                     '(("Recipe" :keys "r" :file "~/Dropbox/org/recipes.org" :headline "Inbox" :type entry
                        :children (("Remote Recipe" :keys "r" :template "%(org-chef-get-recipe-from-url)")
                                   ("Manual Recipe" :keys "m" :template
                                    ("* %^{Recipe title: }"
                                    ":PROPERTIES:"
                                    ":source-url:"
                                    ":servings:"
                                    ":prep-time:"
                                    ":cook-time:"
                                    ":ready-in:"
                                    ":END:"
                                    "** Ingredients"
                                    "%?"
                                    "** Directions"))))))))

(setq org-agenda-custom-commands
      '(("p" "Projects"
         ((todo "" ((org-agenda-overriding-header "Projects")
                    (org-super-agenda-groups
                     '((:name none ;; disable super group headers
                        :auto-property "ProjectId")
                       (:discard (:anything t))))))))
        ("h" "Habits"
         ((agenda "" ((org-agenda-overriding-header "Habits")
                    (org-super-agenda-groups
                     '((:name none
                        :habit t)))))))))

(after! org-roam
  (cl-defmethod org-roam-node-namespace ((node org-roam-node))
    "Return the currently set namespace for the NODE."
    (let ((namespace (cdr (assoc-string "NAMESPACE" (org-roam-node-properties node)))))
      (if (or
           (not namespace)
           (string= namespace (file-name-base (org-roam-node-file node))))
          " Namespace" ; or return the current title, e.g. (org-roam-node-title node)
        (format " %s" namespace))))
  
  (cl-defmethod org-roam-node-topics ((node org-roam-node))
    "Return the currently set namespace for the NODE."
    (let ((topics (cdr (assoc-string "TOPICS" (org-roam-node-properties node)))))
      (if (string= topics (file-name-base (org-roam-node-file node)))
          " (Node Topics)"
        (format "%s" topics))))
  
  
  (setq org-roam-directory "~/Dropbox/roam/"
        org-roam-db-location "~/.org-roam.db"
        org-roam-db-autosync-mode t
        org-roam-completion-everywhere t
        org-roam-node-display-template (concat (propertize "${namespace:15}" 'face '(:foreground "#d3869b" :weight bold)) "${topics:35} ${title:*}" (propertize "${tags:50}" 'face 'org-tag))))


(after! vulpea
  (add-hook! 'org-roam-db-autosync-mode #'vulpea-db-autosync-enable))

(after! deft
  (setq deft-directory "~/Dropbox/org/.deft"))

(defun my/refile (file headline &optional arg)
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile arg nil (list headline file nil pos)))
  (switch-to-buffer (current-buffer)))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(after! org
  (setq org-cite-global-bibliography '("~/Dropbox/biblio/main.bib")))

(after! ox-hugo
  (setq org-hugo-front-matter-format "yaml"
        org-hugo-section "blog"
        org-hugo-paired-shortcodes "cventry mermaid warning"
        org-hugo-auto-set-lastmod t
        org-hugo-suppress-lastmod-period 86400
        org-hugo-special-block-type-properties '(("audio" :raw t)
                                                 ("katex" :raw t)
                                                 ("mark" :trim-pre t :trim-post t)
                                                 ("tikzjax" :raw t)
                                                 ("video" :raw t)
                                                 ("mermaid" :raw t)))
  (add-to-list 'org-export-global-macros '(("srcstart" . "@@hugo:<details><summary class=\"font-bold underline\">$1</summary>@@")
                                           ("srcend" . "@@hugo:</details>@@"))))

(after! ox-pandoc
  (setq org-pandoc-options-for-markdown_strict '((standalone . t)))
  (defun org-pandoc-publish-to (format plist filename pub-dir)
  (setq org-pandoc-format format)
  (let ((tempfile
   (org-publish-org-to
    'pandoc filename (concat (make-temp-name ".tmp") ".org") plist pub-dir))
  (outfile (format "%s.%s"
           (concat
            pub-dir
            (file-name-sans-extension (file-name-nondirectory filename)))
           (assoc-default format org-pandoc-extensions))))
    (let ((process
     (org-pandoc-run tempfile outfile format 'org-pandoc-sentinel
             org-pandoc-option-table))
    (local-hook-symbol
     (intern (format "org-pandoc-after-processing-%s-hook" format))))
      (process-put process 'files (list tempfile))
      (process-put process 'output-file filename)
      (process-put process 'local-hook-symbol local-hook-symbol))))

(defun org-pandoc-publish-to-markdown (p f pd)
  (org-pandoc-publish-to 'markdown p f pd)))

(after! treesitter
  (setq treesit-language-source-alist
      '((astro "https://github.com/virchau13/tree-sitter-astro")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))))

;(use-package! ox-moderncv)
;(use-package! ox-hugocv)

(after! magit-delta
  (add-hook! 'magit-mode #'magit-delta-mode))

(after! citar
  (setq citar-bibliography '("~/Dropbox/biblio/main.bib")
        citar-symbols
        `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
          (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
          (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " "))
        citar-symbol-separator "  "
        citar-templates
        '((main . "${=key= id:25}  ${title:48}  ${author editor:30}  ${date year issued:4}")
          (suffix . "          ${=type=:12}    ${tags keywords:*}")
          (preview . " ${=key= id:15} ${author editor} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
          (note . "Notes on ${author editor}, ${title}"))))

(defun edit-biblio ()
  "Edit global bibliography"
  (interactive)
  (ebib (car org-cite-global-bibliography)))

(after! elfeed
  (setq elfeed-search-filter "@2-weeks-ago +unread"
        elfeed-db-directory "~/Dropbox/.elfeed")

  (defun elfeed-mark-all-as-read ()
      (interactive)
      (mark-whole-buffer)
      (elfeed-search-untag-all-unread))

  (map! :map elfeed-search-mode-map
        :desc "Mark Entries as read" "a" #'elfeed-mark-all-as-read))

(after! elfeed-org
  (setq rmh-elfeed-org-files '("~/Dropbox/org/elfeed.org")))

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

(setq doom-leader-alt-key "C-SPC")

(map! :leader
      (:desc "Find file in project" ":" #'projectile-find-file)
      (:desc "M-x" "SPC" #'execute-extended-command))
