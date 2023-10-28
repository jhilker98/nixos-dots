(when (featurep! :ui hydra +childframe)
  (package! hydra-posframe
    :recipe (:host github :repo "Ladicle/hydra-posframe")))

(when (featurep! :ui hydra +pretty)
  (package! pretty-hydra
    :recipe (:host github :repo "jerrypnz/major-mode-hydra.el" :files ("pretty-hydra.el"))))

(when (featurep! :lang web +lipsum)
  (package! lorem-ipsum))

(package! lsp-tailwindcss :recipe (:host github :repo "merrickluo/lsp-tailwindcss"))

(when (featurep! :ui hydra +childframe)
  (package! hydra-posframe
    :recipe (:host github :repo "Ladicle/hydra-posframe")))

(when (featurep! :ui hydra +pretty)
  (package! pretty-hydra
    :recipe (:host github :repo "jerrypnz/major-mode-hydra.el" :files ("pretty-hydra.el"))))

(package! org-reveal)

(package! org-super-agenda)
(package! doct)
(package! org-ql)
(package! org-recur)
(package! org-trello)

(when (featurep! :lang org +roam2)
  (package! vulpea)
  (package! org-roam-ui))

(package! denote)

(package! binder)

(package! astro-ts-mode
  :recipe ( :host github :repo "Sorixelle/astro-ts-mode"))

(package! esxml)
(package! simple-httpd)

(package! decide)

(package! org-chef)

;(when (featurep! :lang org +moderncv)
;  (package! ox-moderncv
;    :recipe (:host gitlab :repo "jhilker/org-cv")))
;
;(when (featurep! :lang org +hugo)
;  (package! ox-hugocv
;    :recipe (:host gitlab :repo "jhilker/org-cv")))

(package! magit-delta)

(package! wakatime-mode)

(package! virtualenvwrapper)

(package! lorem-ipsum)

(when (featurep! :tools biblio)
  (package! ebib))

(when (featurep! :app rss)
  (package! elfeed-summary
    :recipe (:host github :repo "SqrtMinusOne/elfeed-summary")))
