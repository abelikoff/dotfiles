;; $Id$


;;; paths

(setq load-path (append (mapcar #'expand-file-name
				'("~/lib/elisp/elc"
				  "~/lib/elisp"
				  "/opt/local/emacs/"
				  ))
			load-path))



;;; general packages

(load "crypt++" t t t)


;;; X11 setup

(setq default-frame-alist
      '((width . 80)
	(height . 80)
	(menu-bar-lines . 0)
	(tool-bar-lines . 0)
	(vertical-scroll-bars . nil)
;;	(font . "-dec-terminal-medium-r-normal-*-*-140-*-*-c-*-iso8859-1")
	(font . "-xos4-terminus-medium-r-normal--14-140-*-*-*-*-*-*")
	(foreground-color . "Gray80")
))

(tool-bar-mode 0)
(menu-bar-mode 0)

;; Emacs on *stupid* AIX and Solaris boxes doesn't handle 'background-color'
;; frame attribute properly

(if window-system
    (if (string-match "\\(aix\\|solaris\\)" system-configuration)
	(set-background-color "Black")
      (add-to-list 'default-frame-alist '(background-color . "Black"))))

;; (set-background-color "rgbi:.325/.91/.52")   ;; Harvey's colors


;;; Font-lock configuration

(require 'font-lock)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)


;;; color-theme

(let ((dir (expand-file-name "~/lib/elisp/color-theme")))
  (cond ((file-exists-p dir)
	 (add-to-list 'load-path dir))))

(require 'color-theme)

(autoload 'zenburn "zenburn" "Load zenburn" t)

(defun color-theme-black ()
  "Gray on black theme - made from Arjen theme"
  
  (interactive)
  (color-theme-install
   '(color-theme-black
     ((background-color . "black")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "OrangeRed")
      (foreground-color . "Gray")
      (mouse-color . "OrangeRed"))
     ((buffers-tab-face . buffers-tab)
      (cperl-here-face . font-lock-string-face)
      (cperl-invalid-face quote underline)
      (cperl-pod-face . font-lock-comment-face)
      (cperl-pod-head-face . font-lock-variable-name-face)
      (vc-mode-face . highlight))
     (default ((t (:background "black" :foreground "Gray80"))))
     (blue ((t (:foreground "blue"))))
     (bold ((t (:bold t))))
     (bold-italic ((t (:bold t))))
     (border-glyph ((t (nil))))
     (buffers-tab ((t (:background "black" :foreground "Gray80"))))
     (calendar-today-face ((t (:underline t))))
     (cperl-array-face ((t (:foreground "darkseagreen"))))
     (cperl-hash-face ((t (:foreground "darkseagreen"))))
     (cperl-nonoverridable-face ((t (:foreground "SkyBlue"))))
     (custom-button-face ((t (nil))))
     (custom-changed-face ((t (:background "blue" :foreground "white"))))
     (custom-documentation-face ((t (nil))))
     (custom-face-tag-face ((t (:underline t))))
     (custom-group-tag-face ((t (:underline t :foreground "light blue"))))
     (custom-group-tag-face-1 ((t (:underline t :foreground "pink"))))
     (custom-invalid-face ((t (:background "red" :foreground "yellow"))))
     (custom-modified-face ((t (:background "blue" :foreground "white"))))
     (custom-rogue-face ((t (:background "black" :foreground "pink"))))
     (custom-saved-face ((t (:underline t))))
     (custom-set-face ((t (:background "white" :foreground "blue"))))
     (custom-state-face ((t (:foreground "lime green"))))
     (custom-variable-button-face ((t (:underline t :bold t))))
     (custom-variable-tag-face ((t (:underline t :foreground "light blue"))))
     (diary-face ((t (:foreground "IndianRed"))))
     (diff-added-face ((t (:foreground "Green"))))
     (diff-header-face ((t (:background "Gray" :foreground "Black"))))
     (diff-removed-face ((t (:foreground "Red"))))
     (erc-action-face ((t (:bold t))))
     (erc-bold-face ((t (:bold t))))
     (erc-default-face ((t (nil))))
     (erc-direct-msg-face ((t (:foreground "sandybrown"))))
     (erc-error-face ((t (:bold t :foreground "IndianRed"))))
     (erc-input-face ((t (:foreground "Beige"))))
     (erc-inverse-face ((t (:background "wheat" :foreground "darkslategrey"))))
     (erc-notice-face ((t (:foreground "MediumAquamarine"))))
     (erc-pal-face ((t (:foreground "pale green"))))
     (erc-prompt-face ((t (:foreground "MediumAquamarine"))))
     (erc-underline-face ((t (:underline t))))
     (eshell-ls-archive-face ((t (:bold t :foreground "IndianRed"))))
     (eshell-ls-backup-face ((t (:foreground "Grey"))))
     (eshell-ls-clutter-face ((t (:foreground "DimGray"))))
     (eshell-ls-directory-face ((t (:bold t :foreground "MediumSlateBlue"))))
     (eshell-ls-executable-face ((t (:foreground "Coral"))))
     (eshell-ls-missing-face ((t (:foreground "black"))))
     (eshell-ls-picture-face ((t (:foreground "Violet"))))
     (eshell-ls-product-face ((t (:foreground "sandybrown"))))
     (eshell-ls-readonly-face ((t (:foreground "Aquamarine"))))
     (eshell-ls-special-face ((t (:foreground "Gold"))))
     (eshell-ls-symlink-face ((t (:foreground "White"))))
     (eshell-ls-unreadable-face ((t (:foreground "DimGray"))))
     (eshell-prompt-face ((t (:foreground "MediumAquamarine"))))
;;     (fixme-face ((t (:bold t :foreground "White" :background "Red"))))
     (fl-comment-face ((t (:foreground "pink"))))
     (fl-doc-string-face ((t (:foreground "purple"))))
     (fl-function-name-face ((t (:foreground "red"))))
     (fl-keyword-face ((t (:foreground "cadetblue"))))
     (fl-string-face ((t (:foreground "green"))))
     (fl-type-face ((t (:foreground "yellow"))))
     (font-lock-builtin-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-comment-face ((t (:foreground "Orange"))))
     (font-lock-comment-delimiter-face ((t (:foreground "Orange"))))
     ;;(font-lock-constant-face ((t (:foreground "Green"))))
     (font-lock-constant-face ((t (nil))))
     (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
     (font-lock-function-name-face ((t (:bold t :foreground "Magenta"))))
     ;;(font-lock-keyword-face ((t (:foreground "PaleYellow"))))
     (font-lock-keyword-face ((t (:foreground "PaleYellow" :bold t))))
     (font-lock-preprocessor-face ((t (:foreground "Yellow" :bold t))))
     (font-lock-reference-face ((t (:foreground "SlateBlue"))))
     ;;(font-lock-string-face ((t (:foreground "IndianRed"))))
     (font-lock-string-face ((t (:foreground "DarkCyan"))))
     (font-lock-type-face ((t (nil))))
     ;;(font-lock-variable-name-face ((t (nil))))
     (font-lock-variable-name-face ((t (:foreground "PaleGreen"))))
     (font-lock-warning-face ((t (:bold t :background "Red" :foreground "White"))))
     (qt-classes-face ((t (:foreground "Red"))))
     (gnus-cite-attribution-face ((t (nil))))
     (gnus-cite-face-1 ((t (:bold nil :foreground "deep sky blue"))))
     (gnus-cite-face-10 ((t (:foreground "medium purple"))))
     (gnus-cite-face-11 ((t (:foreground "turquoise"))))
     (gnus-cite-face-2 ((t (:bold nil :foreground "cadetblue"))))
     (gnus-cite-face-3 ((t (:bold nil :foreground "gold"))))
     (gnus-cite-face-4 ((t (:foreground "light pink"))))
     (gnus-cite-face-5 ((t (:foreground "pale green"))))
     (gnus-cite-face-6 ((t (:bold nil :foreground "chocolate"))))
     (gnus-cite-face-7 ((t (:foreground "orange"))))
     (gnus-cite-face-8 ((t (:foreground "magenta"))))
     (gnus-cite-face-9 ((t (:foreground "violet"))))
     (gnus-emphasis-bold ((t (:bold nil))))
     (gnus-emphasis-bold-italic ((t (:bold nil))))
     (gnus-emphasis-highlight-words ((t (:background "black" :foreground "yellow"))))
     (gnus-emphasis-italic ((t (nil))))
     (gnus-emphasis-underline ((t (:underline t))))
     (gnus-emphasis-underline-bold ((t (:underline t :bold nil))))
     (gnus-emphasis-underline-bold-italic ((t (:underline t :bold nil))))
     (gnus-emphasis-underline-italic ((t (:underline t))))
     (gnus-group-mail-1-empty-face ((t (:foreground "aquamarine1"))))
     (gnus-group-mail-1-face ((t (:bold nil :foreground "aquamarine1"))))
     (gnus-group-mail-2-empty-face ((t (:foreground "aquamarine2"))))
     (gnus-group-mail-2-face ((t (:bold nil :foreground "aquamarine2"))))
     (gnus-group-mail-3-empty-face ((t (:foreground "aquamarine3"))))
     (gnus-group-mail-3-face ((t (:bold nil :foreground "aquamarine3"))))
     (gnus-group-mail-low-empty-face ((t (:foreground "aquamarine4"))))
     (gnus-group-mail-low-face ((t (:bold nil :foreground "aquamarine4"))))
     (gnus-group-news-1-empty-face ((t (:foreground "PaleTurquoise"))))
     (gnus-group-news-1-face ((t (:bold nil :foreground "PaleTurquoise"))))
     (gnus-group-news-2-empty-face ((t (:foreground "turquoise"))))
     (gnus-group-news-2-face ((t (:bold nil :foreground "turquoise"))))
     (gnus-group-news-3-empty-face ((t (nil))))
     (gnus-group-news-3-face ((t (:bold nil))))
     (gnus-group-news-4-empty-face ((t (nil))))
     (gnus-group-news-4-face ((t (:bold nil))))
     (gnus-group-news-5-empty-face ((t (nil))))
     (gnus-group-news-5-face ((t (:bold nil))))
     (gnus-group-news-6-empty-face ((t (nil))))
     (gnus-group-news-6-face ((t (:bold nil))))
     (gnus-group-news-low-empty-face ((t (:foreground "DarkTurquoise"))))
     (gnus-group-news-low-face ((t (:bold nil :foreground "DarkTurquoise"))))
     (gnus-header-content-face ((t (:foreground "forest green"))))
     (gnus-header-from-face ((t (:bold nil :foreground "spring green"))))
     (gnus-header-name-face ((t (:foreground "deep sky blue"))))
     (gnus-header-newsgroups-face ((t (:bold nil :foreground "purple"))))
     (gnus-header-subject-face ((t (:bold nil :foreground "orange"))))
     (gnus-signature-face ((t (:bold nil :foreground "khaki"))))
     (gnus-splash-face ((t (:foreground "Brown"))))
     (gnus-summary-cancelled-face ((t (:background "black" :foreground "yellow"))))
     (gnus-summary-high-ancient-face ((t (:bold nil :foreground "SkyBlue"))))
     (gnus-summary-high-read-face ((t (:bold nil :foreground "PaleGreen"))))
     (gnus-summary-high-ticked-face ((t (:bold nil :foreground "pink"))))
     (gnus-summary-high-unread-face ((t (:bold nil))))
     (gnus-summary-low-ancient-face ((t (:foreground "SkyBlue"))))
     (gnus-summary-low-read-face ((t (:foreground "PaleGreen"))))
     (gnus-summary-low-ticked-face ((t (:foreground "pink"))))
     (gnus-summary-low-unread-face ((t (nil))))
     (gnus-summary-normal-ancient-face ((t (:foreground "SkyBlue"))))
     (gnus-summary-normal-read-face ((t (:foreground "PaleGreen"))))
     (gnus-summary-normal-ticked-face ((t (:foreground "pink"))))
     (gnus-summary-normal-unread-face ((t (nil))))
     (gnus-summary-selected-face ((t (:underline t))))
     (green ((t (:foreground "green"))))
     (gui-button-face ((t (:background "grey75" :foreground "black"))))
     (gui-element ((t (:background "#D4D0C8" :foreground "black"))))
     (highlight ((t (:background "darkolivegreen"))))
     (highline-face ((t (:background "SeaGreen"))))
     (holiday-face ((t (:background "DimGray"))))
     (info-menu-5 ((t (:underline t))))
     (info-node ((t (:underline t :bold t :foreground "DodgerBlue1"))))
     (info-xref ((t (:bold t :foreground "Orange"))))
     (isearch ((t (:background "blue"))))
     (isearch-secondary ((t (:foreground "red3"))))
     (italic ((t (nil))))
     (left-margin ((t (nil))))
     (list-mode-item-selected ((t (:background "gray68" :foreground "white"))))
     (message-cited-text-face ((t (:bold t :foreground "green"))))
     (message-header-cc-face ((t (:bold t :foreground "green4"))))
     (message-header-name-face ((t (:bold t :foreground "orange"))))
     (message-header-newsgroups-face ((t (:bold t :foreground "violet"))))
     (message-header-other-face ((t (:bold t :foreground "chocolate"))))
     (message-header-subject-face ((t (:bold t :foreground "yellow"))))
     (message-header-to-face ((t (:bold t :foreground "cadetblue"))))
     (message-header-xheader-face ((t (:bold t :foreground "light blue"))))
     (message-mml-face ((t (:bold t :foreground "Green3"))))
     (message-separator-face ((t (:foreground "blue3"))))
;;      (modeline ((t (:background "Gray60"
;; 		    :foreground "Black"
;; 		    :box (:line-width 1 :style released-button)))))
     (modeline ((t (:background "Gray60" :foreground "Black"))))
     (mode-line-inactive ((t (:background "Gray60" :foreground "Black"))))
     (modeline-buffer-id ((t (:bold t :background "Gray60"
				      :foreground "Black"))))
     (modeline-mousable ((t (:background "Gray60" :foreground "Black"))))
     (modeline-mousable-minor-mode ((t (:background "Gray60"
					:foreground "Black"))))
     (p4-depot-added-face ((t (:foreground "blue"))))
     (p4-depot-deleted-face ((t (:foreground "red"))))
     (p4-depot-unmapped-face ((t (:foreground "grey30"))))
     (p4-diff-change-face ((t (:foreground "dark green"))))
     (p4-diff-del-face ((t (:foreground "red"))))
     (p4-diff-file-face ((t (:background "gray90"))))
     (p4-diff-head-face ((t (:background "gray95"))))
     (p4-diff-ins-face ((t (:foreground "blue"))))
     (pointer ((t (nil))))
     (primary-selection ((t (:background "blue"))))
     (red ((t (:foreground "red"))))
     (region ((t (:background "blue"))))
     (right-margin ((t (nil))))
     (secondary-selection ((t (:background "darkslateblue"))))
     (show-paren-match-face ((t (:background "Aquamarine" :foreground "SlateBlue"))))
     (show-paren-mismatch-face ((t (:background "Red" :foreground "White"))))
     (text-cursor ((t (:background "yellow" :foreground "black"))))
     (toolbar ((t (nil))))
     (underline ((nil (:underline nil))))
     (vertical-divider ((t (nil))))
     (widget ((t (nil))))
     (widget-button-face ((t (:bold t))))
     (widget-button-pressed-face ((t (:foreground "red"))))
     (widget-documentation-face ((t (:foreground "lime green"))))
     (widget-field-face ((t (:background "dim gray"))))
     (widget-inactive-face ((t (:foreground "light gray"))))
     (widget-single-line-field-face ((t (:background "dim gray"))))
     (woman-bold-face ((t (:bold t))))
     (woman-italic-face ((t (:foreground "beige"))))
     (woman-unknown-face ((t (:foreground "LightSalmon"))))
     (yellow ((t (:foreground "yellow"))))
     (zmacs-region ((t (:background "snow" :foreground "blue")))))))

(color-theme-black)



;;
;; global settings
;;

(line-number-mode 1)
(column-number-mode 1)
(global-set-key "\r" 'reindent-then-newline-and-indent)

(let ((dir (expand-file-name "~/tmp/emacs-backup/")))
  (if (file-exists-p dir)
      (setq backup-directory-alist `((".*" . ,dir)))))

(setq-default inhibit-startup-message t
              initial-scratch-message nil
              default-major-mode 'indented-text-mode
              next-line-add-newlines nil
              require-final-newline nil
              modeline-click-swaps-buffers t
              indent-tabs-mode nil
              )

(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(toggle-save-place-globally)

(global-set-key [f8] 'next-error)
(global-set-key [S-f8] 'previous-error)


;;; C mode

(setq-default c-style-variables-are-local-p nil)
(setq-default c-basic-offset 4)

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq-default c-basic-offset 4)
	    (imenu-add-to-menubar "Functions")
	    (font-lock-add-keywords
	     nil
	     '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


;;; CPerl mode

(mapc
 (lambda (pair)
   (if (eq (cdr pair) 'perl-mode)
       (setcdr pair 'cperl-mode)))
 (append auto-mode-alist interpreter-mode-alist))

(add-hook 'cperl-mode-hook
	  (lambda ()
	    (local-set-key [f1] 'cperl-perldoc-at-point)
	    (font-lock-add-keywords
	     nil
	     '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 4)
(setq cperl-brace-offset 0)
(setq cperl-label-offset -4)


;;; Diary/Appt

(setq diary-file "~/.diary")

(setq-default display-time-format "[%H:%M]")
(add-hook 'diary-hook 'appt-make-list)
(add-hook 'diary-display-hook 'fancy-diary-display)
(display-time)


;;; ESS

;;(setq-default ess-continued-statement-offset 4)
(setq-default ess-indent-level 4)


;;; GDB

;;(require "'speedbar")
;;(setq gdb-many-windows t)


;;; imenu

(require 'imenu)


;;; indentation

(require 'filladapt)
(setq-default filladapt-mode t)
(setq sentence-end-double-space nil)

(push '("\\(>\\| \\|:\\||\\)+?" citation->) filladapt-token-table)
(setq-default adaptive-fill-mode nil)
(setq-default filladapt-mode t)
(setq-default filladapt-mode-line-string nil)

(setq sentence-end-double-space nil
      sentence-end "[.?!][]\"')}]*\\($\\| $\\|	\\| \\)[ 	\n]*")


;;; man/woman

(autoload 'woman "woman" "Load woman" t)
(global-set-key [f1] 'man-word)


;;; org-mode

(let ((dir "~/lib/elisp/org-mode/lisp"))
  (cond ((file-exists-p (concat dir "/org-install.el"))
	 (add-to-list 'load-path (expand-file-name dir))
	 (require 'org-install)
	 (eval-after-load 'info
	   '(add-to-list 'Info-directory-list 
			 (concat dir "/../info"))))))

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

(setq org-todo-keyword-faces
      '(("TODO"  . (:foreground "Yellow" :weight bold))))




;;; parenthesis matching

(require 'paren)
(setq show-paren-style 'mixed)
(show-paren-mode 1)

(set-face-foreground 'show-paren-mismatch-face "White")
(set-face-background 'show-paren-mismatch-face "Red")
(set-face-background 'show-paren-match-face "Blue")

;;(paren-set-mode 'blink-paren)


;; load tags

(defun load-bbsrc-tags ()
  (interactive "")

  (let ((pfx "/bbsrc/tools/tags/")
	(libs '("acclib" "appscrn" "apptwoline" "apputil" "calclib" "datelib"
		"dbutil" "derscrn" "derutil" "mathutil" "msgutil" "mtgescrn"
		"mtgeutil" "peutil" "rptutil" "volderlib")))
    (setq tags-table-list 
	  (append tags-table-list
		  (mapcar (lambda (e) (concat pfx e)) libs)))))

;; (let* ((tag-dir "/zzz/bbsrc/tools/tags"))
;;   (if (file-directory-p tag-dir)
;;       (setq tags-table-list 
;; 	    (remove-if (lambda (x)
;; 			 (or (not (file-directory-p x))
;; 			     (string-match "\\.\\.*$" x)))
;; 		       (directory-files tag-dir t))))))



;;; Version control

(setq diff-switches "-uw")
;;(add-to-list 'vc-handled-backends 'SVN)


;;; Cyrillic support

;(require 'russian)
;(require 'rusup)

;;(global-set-key [f7] 'russify-region)
;; Control-F7
;;(global-set-key (if emacs-is-xemacs [(control f7)] [C-f7]) 'russify-line)
;; Shift-F7
;;(global-set-key (if emacs-is-xemacs [(shift f5)] [S-f17]) 'russify-word)
;;(global-set-key [f8] 'russian-insertion-mode)


;;; Mailcrypt

;(load-library "mailcrypt")
;(mc-setversion "gpg")


;;; Matlab

(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)
(setq-default matlab-shell-command "octave_wrapper")
(setq octave-comment-char ?%)


;;; PHP mode

(autoload 'php-mode "php-mode" "PHP Mode" t)


;;; Print setup
 
;; (setq lpr-switches '("-Pduplex"))


;;; Voctest

(autoload 'voctest "voctest"
  "Vocabulary testing program" t)


;;; Webster dictionary

(autoload 'webster-lookup "webdic"
  "Webster Dictionary lookup" t)

(autoload 'webster-lookup-under-cursor "webdic"
  "Webster Dictionary lookup for the word at the point" t)

(global-set-key [S-f11] 'webster-lookup-under-cursor)


;;; word-help

(autoload 'set-help-file "word-help"
  "Sets the set of Texinfo files used for `word-help' to HELPFILE." t nil)
(autoload 'word-help "word-help"
  "Find documentation on the KEYWORD under the cursor (or passed)." t nil)
(autoload 'word-help-complete "word-help"
  "Perform completion on the symbol preceding the point." t nil)
(autoload 'word-help-add-keywords "word-help"
  "Add user keywords to a certain Info file." nil nil)

(define-key help-map [?\C-i] 'word-help)
;;(global-set-key [\C-tab] 'word-help-complete)


;; Compilation setup

(global-set-key "\C-c\C-m" 'compile)
(global-set-key "\C-cm" 'compile)

;;(require 'compile)
;; (setq compilation-error-regexp-alist
;;       (append
;;        (list
;; 	'("\\(\n\\|on \\|before \\|after \\)[Ll]ine[ \t]+\\([0-9]+\\)[ \t]+\
;; of[ \t]+\"?\\([^\":\n]+\\)\"?:" 3 2)
;; 	'("\n\\([^, \n]+\\), line \\([0-9]+\\)[^:]*: \\(Warning:\\|Note:\\|Error:\\)" 1 2))
;;        compilation-error-regexp-alist))


(defun todo-list ()
  "Show all occurences of FIXME and TODO tags in the current source tree."

  (interactive "")
  (let ((null-device nil))
    (grep "find . -type f | cut -c 3- | egrep -v '(~|\.o)$' | egrep -v '(^CVS/|/CVS/|^\.svn/|/\.svn/| )' | xargs egrep -n '(FIXME|TODO):' | egrep -v '^Binary file .* matches'")))


;; Lisp mode setup

; (add-hook 'ilisp-load-hook
;   '(lambda ()
;      (define-key global-map "\C-c1" 'ilisp-bury-output)
;      (define-key global-map "\C-cv" 'ilisp-scroll-output)
;      (define-key global-map "\C-cg" 'ilisp-grow-output)))


(autoload 'run-ilisp   "ilisp" "Select a new inferior Lisp." t)
(autoload 'common-lisp "ilisp" "Inferior generic Common Lisp." t)
(autoload 'clisp-hs    "ilisp" "Inferior CLISP Common Lisp." t)
(autoload 'scheme      "ilisp" "Inferior generic Scheme." t)
(autoload 'guile       "ilisp" "Inferior GUILE Scheme." t)

(setq clisp-hs-program "clisp -I")
(setq guile-program "guile")

(set-default 'auto-mode-alist
	     (append '(("\\.lisp$" . lisp-mode)
                       ("\\.lsp$" . lisp-mode)
                       ("\\.cl$" . lisp-mode))
                     auto-mode-alist))

(setq lisp-mode-hook 
      (lambda () 
	(require 'ilisp)
	(imenu-add-to-menubar "Functions")
	(font-lock-add-keywords
	 nil
	 '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


(setq emacs-lisp-mode-hook 
      (lambda () 
	(imenu-add-to-menubar "Functions")
	(local-set-key [f1] 'describe-function)
	(local-set-key [S-f1] 'describe-variable)
	(font-lock-add-keywords
	 nil
	 '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


(setq ilisp-*use-fsf-compliant-keybindings* t)

(set-default 'auto-mode-alist
             (append '(("\\.scm$" . scheme-mode)
                       ("\\.ss$" . scheme-mode)
                       ("\\.stk$" . scheme-mode)
                       ("\\.stklos$" . scheme-mode))
                     auto-mode-alist))

(setq scheme-mode-hook '(lambda () (require 'ilisp)))


;; (add-hook 'ilisp-load-hook
;;           '(lambda ()
;;              ;; Change default key prefix to C-c
;;              (setq ilisp-*prefix* "\C-c")

;;              ;; Set a keybinding for the COMMON-LISP-HYPERSPEC command
;;              (defkey-ilisp "" 'common-lisp-hyperspec)

;;              ;; Make sure that you don't keep popping up the 'inferior
;;              ;; Lisp' buffer window when this is already visible in
;;              ;; another frame. Actually this variable has more impact
;;              ;; than that. Watch out.
;;              ; (setq pop-up-frames t)

;;              (message "Running ilisp-load-hook")
;;              ;; Define LispMachine-like key bindings, too.
;;              ; (ilisp-lispm-bindings) Sample initialization hook.

;;              ;; Set the inferior Lisp directory to the directory of
;;              ;; the buffer that spawned it on the first prompt.
;;              (add-hook 'ilisp-init-hook
;;                        '(lambda ()
;;                           (default-directory-lisp ilisp-last-buffer)))
;;              ))


; (setq inferior-lisp-program "lisp")
; (define-key lisp-interaction-mode-map "\C-cd" 'lisp-send-defun)
; (define-key lisp-interaction-mode-map "\C-cj" 'lisp-send-defun-and-go)

; (defun my-lisp-family-setup ()
;   (local-set-key [f1]   'clman-word)
;   (local-set-key "\C-cd" 'lisp-send-defun)
;   (local-set-key "\C-cj" 'lisp-send-defun-and-go))


; (add-hook 'lisp-mode-hook #'my-lisp-family-setup)
; (add-hook 'inferior-lisp-mode-hook #'my-lisp-family-setup)

; (add-hook 'emacs-lisp-mode-hook
; 	  (function (lambda ()
; ;;		      (local-set-key [f8] 'eval-and-advance)
; 		      )))


;; HyperSpec

(setq common-lisp-hyperspec-root
      "file:/usr/local/doc/HyperSpec/")
(setq common-lisp-hyperspec-symbol-table
      "/usr/local/doc/HyperSpec/Data/Map_Sym.txt")


;; CLtL2

(setq cltl2-root-url "file:/usr/local/doc/cltl2/")


;; Scheme mode

(setq scheme-program-name "scsh")

(setq cmuscheme-load-hook
      '((lambda () (define-key inferior-scheme-mode-map "\C-c\C-t"
		     'favorite-cmd))))


;; TeX/LaTeX

(load "auctex.el" t t t)
(load "preview-latex.el" t t t)

;(eval-after-load 'info
;  '(add-to-list 'Info-directory-list "~/lib/elisp/auctex"))


(defun insert-latex-env-abbrev ()
  (let ((oldp (point)))
    (previous-line 3)
    (indent-region (point) oldp nil))
  (indent-according-to-mode)
  (next-line 1)
  (indent-according-to-mode))


(add-hook 'LaTeX-mode-hook
          (lambda ()
            (push `("^pdf$" "." "acroread %o") TeX-output-view-style)
	    (turn-on-auto-fill)
	    (setq abbrev-mode t)

	    ;; abbreviations

	    (define-abbrev text-mode-abbrev-table "\\a" "\\alpha" nil)
	    (define-abbrev text-mode-abbrev-table "gga" "\\alpha" nil)
	    (define-abbrev text-mode-abbrev-table "ggb" "\\beta" nil)
	    (define-abbrev text-mode-abbrev-table "ggg" "\\gamma" nil)
	    (define-abbrev text-mode-abbrev-table "ggd" "\\delta" nil)
	    (define-abbrev text-mode-abbrev-table "ggf" "\\phi" nil)
	    (define-abbrev text-mode-abbrev-table "ggr" "\\rho" nil)
	    (define-abbrev text-mode-abbrev-table "ggs" "\\sigma" nil)
	    
	    (mapcar
	     (lambda (e)
	       (define-abbrev text-mode-abbrev-table (car e) 
		 (format "\\begin{%s}\n\n\\end{%s}\n" (cdr e) (cdr e))
		 '(lambda ()
		    (insert-latex-env-abbrev))))
	     '(("eal" . "align*")
	       ("ega" . "gather*")
	       ("ee" . "")
	       ("eeq" . "equation")
	       ("een" . "enumerate")
	       ("eit" . "itemize")
	       ))

	    (font-lock-add-keywords
	     nil
	     '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)
	       ("\\<\\(fixme *.*\\)" 1 font-lock-warning-face t)))))

(setq
    TeX-pdf-mode  t			; generate PDF
)


;; shell script mode

(add-hook 'sh-mode-hook
	  (lambda ()
	    (font-lock-add-keywords
	     nil
	     '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


;; Comint mode setup

(require 'comint)
(setq comint-output-filter-functions
      (cons #'comint-watch-for-password-prompt
	    comint-output-filter-functions))


;; Browse URL

(setq browse-url-browser-function #'browse-url-gnome-moz)


;; find file at point

;; (require 'ffap)
;; (ffap-bindings)

;; (setq ffap-require-prefix t
;;       ffap-c-path (append '("/usr/include")
;; 			  ))
;			  (mapcar (lambda (s) (concat
;					       "/home/aaron/app/var/src/"
;					       s))
;				  '("block-data" "containers" "cov-method" "db"
;				    "dg1-tsk" "drivers" "foreign"
;				    "global-headers" "makefiles" "mapping"
;				    "primitives" "slatec" "structures"
;				    "util"))))




;; Emacs server

;(server-start))


(global-set-key [f3] 'shell-other-window)
(global-set-key "\C-cg" 'goto-line)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'message-mode-hook 'turn-on-auto-fill)
;(add-hook 'text-mode-hook 'turn-on-filladapt-mode)
;(add-hook 'mail-mode-hook 'turn-on-filladapt-mode)
;(add-hook 'tex-mode-hook 'turn-on-filladapt-mode)
;(add-hook 'latex-mode-hook 'turn-on-filladapt-mode)

(add-hook 'forms-mode-hooks
	  (function (lambda ()
		      (local-set-key [S-right] 'forms-next-field)
		      (local-set-key [S-left] 'forms-next-field))))

;; redefine indent-for-comment to kill the comment with negative prefix

(defadvice indent-for-comment (around kill-comment activate)
  "Kill the comment with negative prefix."
  (if (eq current-prefix-arg '-)
      (kill-comment nil)
    ad-do-it))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Useful Routines
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; auto-startup stuff

(defun auto-startup ()
  "Convenience function to be called by the first emacs, which is brought
up automatically"
  
  (interactive)
;;  (run-at-time 20 nil 'get-daily-comic "dilbert")
  (diary)
  (gnus-other-frame)
  )


(defun eval-and-advance ()
  "Evaluate next sexp and advance"
  (interactive "*")
  (forward-sexp)
  (eval-last-sexp nil))


(defun run-stk ()
  "Run STk as an inferior Scheme"

  (interactive "*")
  (run-scheme "stk"))


(defun run-xlispstat ()
  "Run XLISP-STAT as an inferior Scheme"

  (interactive "*")
  (run-lisp "xlispstat"))


(defun service-window ()
  "Split screen by two subwindows. Useful for shell, LISP, GDB"

  (interactive)
  (delete-other-windows)
  (split-window)
  (enlarge-window 5)
  (other-window 1))


(defun shell-other-window ()
  "Create a service window and start shell in it"

  (interactive "*")
  (service-window)
  (shell))


(defun man-word ()
  "Show the word under the cursor as man page."

  (interactive)
  (save-excursion
    (let ((beg-word (progn
		      (forward-word -1)
		      (point))))
      (forward-word 1)
      (funcall #'man (buffer-substring beg-word (point))))))


(defun gdb-step-forever (arg)
  "gdb animation"
  (interactive "Time between steps: ")
  (while t
    (progn
      (sit-for arg)
      (gud-step 1))))


(defun voctest-reverse ()
  "Run voctest with reversed test direction"

  (interactive "")
  (let ((voctest-test-direction '(1 . 0)))
    (voctest)))


;; startup

(if (file-exists-p "~/.diary")
    (diary))



;; STUPID Solaris/AIX keep losing bg/fg settings unless default-frame-alist
;; is re-initialized

(if (and window-system
	 (string-match "\\(aix\\|solaris\\)" system-configuration))
    (setq default-frame-alist
	  '((width . 80)
	    (height . 80)
	    (menu-bar-lines . 0)
	    (tool-bar-lines . 0)
	    (vertical-scroll-bars . nil)
	    (font . "-xos4-terminus-medium-r-normal--14-140-*-*-*-*-*-*")
	    (foreground-color . "Gray80")
	    )))


;;; Local Variables:
;;;   mode: outline-minor
;;; End:
