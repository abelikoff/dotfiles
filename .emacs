;; emacs configuration

(require 'cl)

;;; paths

(defun my-filter (condp lst)
  "Filter list elements not matching the predicate."

  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

(setq load-path (append
                 (my-filter 'file-directory-p
                            (mapcar #'expand-file-name
                                    '("/cygdrive/c/tools/elisp"
                                      "/cygdrive/c/tools/elisp/color-theme-6.6.0"
                                      "/cygdrive/c/tools/elisp/ess/lisp"
                                      "~/lib/elisp"
                                      "/opt/local/emacs/"
                                      "/opt/go/misc/emacs"
                                      )))
                 load-path))



;;; load packages

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://stable.melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(let ((packages '(scala-mode ess color-theme web-mode))
      (refreshed nil))
  (dolist (pkg packages)
    (unless (package-installed-p pkg)
      (unless refreshed
        (package-refresh-contents)
        (setq refreshed t))
      (package-install pkg))))


;;(load "crypt++" t t t)


;;; X11 setup

(defconst is-work-desktop
;;;  (and (equal (string-match "sho" system-name) 0)
  (string-match "^sho.*e.com" system-name)
  "Non-nil when running on work desktop.")

(defconst is-windows
  (if (string-match "mingw-nt" system-configuration) t nil)
  "Non-nil when running on Windows.")

(defconst is-macintosh
  (if (string-match "apple-darwin" system-configuration) t nil)
  "Non-nil when running on a Mac.")


(if is-windows
    (setq load-path (append
                     (my-filter 'file-directory-p
                                (mapcar #'expand-file-name
                                        '("C:\\tools\\elisp"
                                          "C:\\tools\\elisp\\color-theme-6.6.0"
                                          "C:\\tools\\elisp\\ess\\lisp")))
                     load-path)))


;; required for tramp on Mac

(if is-macintosh
    (put 'temporary-file-directory 'standard-value
         '((file-name-as-directory "/tmp"))))


(defconst my-default-font
  (cond (is-windows "Hack-11")
        ;;(is-windows "Consolas-11")
        (is-work-desktop "Consolas-11")
        (is-macintosh "Hack-12")
        (t "Droid Sans Mono-9")))


(lexical-let ((current-index 0))
  (defun switch-font ()
    "Rotate between reasonable fonts."

    (interactive "")
    (let ((font-list
           '(
             "DejaVu Sans Mono-10"
             "Droid Sans Mono-12"
             "Hack-12"
             "Liberation Mono-9"
             "Monaco-12"
             "Monospace-9"
             "-dec-terminal-medium-r-normal-*-*-140-*-*-c-*-iso8859-1"
             "-outline-Consolas-normal-r-normal-normal-12-97-96-96-c-*-iso8859-1"
             "-xos4-terminus-medium-r-normal--14-140-*-*-*-*-*-*"
             )))
      (progn
        (setq current-index (mod (1+ current-index) (length font-list)))
        (let ((font (nth current-index font-list)))
          (set-frame-font font)
          (message (concat "Font switched to " font)))))))


(defconst my-default-height
  (cond (is-macintosh 42)
        (is-work-desktop 70)
        (t 50)))

(defconst my-default-bg-color "Black")
(defconst my-default-fg-color "Gray")

(setq default-frame-alist
      `((width . 90)
        (height . ,my-default-height)
        ;;(menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)
        (font . ,my-default-font)
        (foreground-color . ,my-default-fg-color)))

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (tool-bar-mode 0)
      ;;(menu-bar-mode 0)
      ))

;; (set-background-color "rgbi:.325/.91/.52")   ;; Harvey's colors


;;; colors and themes

(require 'font-lock)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(require 'color-theme)

(if (file-exists-p "~/.theme-monokai")
    (require 'monokai-theme)
  (progn
    (require 'color-theme-solarized)
    (color-theme-solarized-dark)))

(add-hook 'window-setup-hook '(lambda () (set-cursor-color "red")))
(add-hook 'after-make-frame-functions
          '(lambda (f) (with-selected-frame f (set-cursor-color "red"))))


;;
;; global settings
;;

(line-number-mode 1)
(column-number-mode 1)
(global-set-key "\r" 'newline-and-indent) ; not reindent-then-newline-and-indent
(global-set-key "\C-cg" 'goto-line)

(let ((dir (expand-file-name (if is-windows
                                 (concat (getenv "TEMP") "/emacs-backup/")
                               "~/tmp/emacs-backup/"))))
  (if (file-exists-p dir)
      (setq backup-directory-alist `((".*" . ,dir)))))

(setq-default inhibit-startup-message t
              initial-scratch-message nil
              default-major-mode 'indented-text-mode
              next-line-add-newlines nil
              require-final-newline nil
              modeline-click-swaps-buffers t
              indent-tabs-mode nil
              ;;printer-name "//nycs01vfp/06SCopier"
              frame-title-format '("" "%b - Emacs " emacs-version)
              line-move-visual nil
              )

(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(toggle-save-place-globally)
(add-hook 'before-save-hook
          (lambda ()
            (conditional-untabify)
            (delete-trailing-whitespace)))

(global-set-key [M-down] 'next-error)
(global-set-key [M-up] '(lambda () (interactive) (next-error -1)))


;;; C mode

(setq-default c-default-style "bsd")
(setq-default c-style-variables-are-local-p nil)
(setq-default c-basic-offset 4)

(add-hook 'c-mode-common-hook
          (lambda ()
            (imenu-add-to-menubar "Functions")
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\):" 1 fixme-face prepend)
                                      ("\\<\\(and\\|or\\|not\\)\\>" .
                                       font-lock-keyword-face)))
            ;; (font-lock-add-keywords
            ;;  nil
            ;;  ;;'(("\\<\\(FIXME:.*\\)" 1 fixme-face t)
            ;;  '(("\bFIXME\b.*" fixme-face)
            ;;    ;;("\\<\\(TODO:.*\\)" 1 todo-face t)
            ;;    ;;("\\<\\(\bTODO\b.*\\)" 1 todo-face t)
            ;;    ))
            ))



;;; column marker

(if (load "column-marker.el" t t t)
    (add-hook 'find-file-hook
              (lambda ()
                (if (and (stringp buffer-file-name)
                         (not (string-match "\\.\\(borg\\|gcl\\)$" buffer-file-name)))
                    (column-marker-1 80)))))


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


;;; DOS batch

(autoload 'dos-mode "dos" "Edit MS-DOS scripts." t)
(add-to-list 'auto-mode-alist '("\\.bat$" . dos-mode))
(add-to-list 'auto-mode-alist '("\\.cmd$" . dos-mode))


;;; ESS

(require 'ess-site)
(add-hook 'ess-mode-hook
          (lambda ()
            (setq ess-continued-statement-offset 4)
            (setq ess-indent-level 4)))


;;; GO

(load "go-mode-load" t t t)
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save nil t)))


;;; GDB

;;(require "'speedbar")
;;(setq gdb-many-windows t)


;;; imenu

(require 'imenu)


;;; indentation

;; (require 'filladapt)
;; (setq-default filladapt-mode t)
;; (setq sentence-end-double-space nil)

;; (push '("\\(>\\| \\|:\\||\\)+?" citation->) filladapt-token-table)
;; (setq-default adaptive-fill-mode nil)
;; (setq-default filladapt-mode t)
;; (setq-default filladapt-mode-line-string nil)

;; (setq sentence-end-double-space nil
;;       sentence-end "[.?!][]\"')}]*\\($\\| $\\|       \\| \\)[        \n]*")


;;; Java


;;; JavaScript / JSON

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))


(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))

;;(require 'js-comint)
(setq inferior-js-program-command "node --interactive")
(add-hook 'js2-mode-hook '(lambda ()
                            (local-set-key "\C-x\C-e" 'js-send-last-sexp)
                            (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
                            (local-set-key "\C-cb" 'js-send-buffer)
                            (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
                            (local-set-key "\C-cl" 'js-load-file-and-go)
                            ))

(setenv "NODE_NO_READLINE" "1")


;;; linum

(setq-default linum-format "%4d  ")
(if (not (load "linum-off.el" t t t))
    (require 'linum))
(global-linum-mode 1)


;;; man/woman

(autoload 'woman "woman" "Load woman" t)
(global-set-key [f1] 'man-word)


;;; org-mode

(defvar org-agenda-files '("~/org/projects"))
(defvar org-agenda-prefix-format '((agenda . "  %-25:c%?-12t% s")
                                   (timeline . "  % s")
                                   (todo . "  %-25:c")
                                   (tags . "  %-25:c")
                                   (search . "  %-25:c")))
(defvar org-agenda-start-on-weekday nil)
(require 'org)
(set-face-foreground 'org-scheduled-previously "OrangeRed")
(set-face-foreground 'org-scheduled-today "Green")
(set-face-foreground 'org-scheduled "Gray")

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)

;;(setq org-todo-keyword-faces
;;      '(("TODO"  . (:foreground "Yellow" :weight bold))))

;;; support for go: links
;;(org-add-link-type "go" (lambda (url)
;;                          (browse-url (concat "http://go/" url))))


(defvar org-journal-file "~/org/journal.org"
  "Path to OrgMode journal file.")

(defvar org-journal-date-format "%Y-%m-%d"
  "Date format string for journal headings.")

(defvar org-journal-time-format "%H:%M"
  "Time format string for journal headings.")

(defun add-journal-entry (entry)
  "Create a new diary entry for today or append to an existing one."
  (interactive "sEntry: ")
    (let ((today (format-time-string org-journal-date-format))
          (current-time (format-time-string org-journal-time-format)))
      (save-excursion
        (set-buffer (find-file-noselect org-journal-file))
        (widen)
        (beginning-of-buffer)
        (unless (search-forward-regexp (concat "^\\* +" today) nil t)
          (progn (org-insert-heading)
                 (insert today)))
        (org-show-subtree)
        (org-narrow-to-subtree)
        (end-of-buffer)
        (org-insert-heading)
        (condition-case nil          ; promotion fails when at the top
            (progn (org-do-promote)
                   (org-do-promote)
                   (org-do-promote)
                   (org-do-promote))
          (error nil))
        (org-do-demote)
        (insert current-time)
        (insert (concat " " entry "\n"))
        (save-buffer))))

;;(global-set-key "\C-cj" 'add-journal-entry)


;;; parenthesis matching

(require 'paren)
(setq show-paren-style 'mixed)
(show-paren-mode 1)
(set-face-foreground 'show-paren-mismatch-face "White")
(set-face-background 'show-paren-mismatch-face "Red")
(set-face-background 'show-paren-match-face "Blue")

;;(paren-set-mode 'blink-paren)


;;; python

;;(require 'python-mode)

;;(setq-default py-shell-name "ipython")
;;(setq-default py-which-bufname "IPython")
;; ; use the wx backend, for both mayavi and matplotlib
;;(setq py-force-py-shell-name-p t)


;;(require 'ipython)

;; ; switch to the interpreter after executing code
;; (setq py-shell-switch-buffers-on-execute-p t)
;; (setq py-switch-buffers-on-execute-p t)
;; ; don't split windows
;; (setq py-split-windows-on-execute-p nil)
;; ; try to automagically figure out indentation
;; (setq py-smart-indentation t)

(add-hook 'python-mode-hook
          (lambda ()
            (set-variable 'py-indent-offset 4)
            (set-variable 'indent-tabs-mode nil)
            (python-indent-guess-indent-offset)))
;;;            (define-key py-mode-map (kbd "RET") 'newline-and-indent)))



;; load tags

(defun load-bbsrc-tags ()
  (interactive "")

  (let ((pfx "/bbsrc/tools/tags/")
        (libs '("acclib" "appscrn")))
    (setq tags-table-list
          (append tags-table-list
                  (mapcar (lambda (e) (concat pfx e)) libs)))))



;;; Version control

(setq diff-switches "-uw")


;;; Cyrillic support

;(require 'russian)
;(require 'rusup)

;;(global-set-key [f7] 'russify-region)
;; Control-F7
;;(global-set-key (if emacs-is-xemacs [(control f7)] [C-f7]) 'russify-line)
;; Shift-F7
;;(global-set-key (if emacs-is-xemacs [(shift f5)] [S-f17]) 'russify-word)
;;(global-set-key [f8] 'russian-insertion-mode)


;;; Matlab

(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)
(setq-default matlab-shell-command "octave_wrapper")
(setq octave-comment-char ?%)


;;; PHP mode

(autoload 'php-mode "php-mode" "PHP Mode" t)


;;; Powershell mode

(setq-default powershell-indent 4)
(autoload 'powershell-mode "powershell-mode"
  "Major mode for editing PowerShell scripts." t)
(add-to-list 'auto-mode-alist '("\\.ps1$" . powershell-mode))


;;; Print setup

;; (setq lpr-switches '("-Pduplex"))


;; protobuf

(autoload 'protobuf-mode "protobuf-mode"
  "Major mode for editing Google Protobuf code." t)
(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))


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

(setq-default compilation-scroll-output 'first-error)
(global-set-key "\C-c\C-m" 'compile)
(global-set-key "\C-cm" 'compile)

;;(require 'compile)
;; (setq compilation-error-regexp-alist
;;       (append
;;        (list
;;      '("\\(\n\\|on \\|before \\|after \\)[Ll]ine[ \t]+\\([0-9]+\\)[ \t]+\
;; of[ \t]+\"?\\([^\":\n]+\\)\"?:" 3 2)
;;      '("\n\\([^, \n]+\\), line \\([0-9]+\\)[^:]*: \\(Warning:\\|Note:\\|Error:\\)" 1 2))
;;        compilation-error-regexp-alist))


(defun todo-list ()
  "Show all occurences of FIXME and TODO tags in the current source tree."

  (interactive "")
  (let ((null-device nil))
    (grep "find . -type f | cut -c 3- | egrep -v '(~|\.o)$' | egrep -v '(^CVS/|/CVS/|^\.svn/|/\.svn/| )' | xargs egrep -n 'FIXME|TODO' | egrep -v '^Binary file .* matches'")))


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

(add-hook 'lisp-mode-hook
          (lambda ()
            (require 'ilisp)
            (imenu-add-to-menubar "Functions")
            (font-lock-add-keywords
             nil
             '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (imenu-add-to-menubar "Functions")
            (local-set-key [f1] 'describe-function)
            (local-set-key [S-f1] 'describe-variable)
            (font-lock-add-keywords
             nil
             '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


(setq ilisp-*use-fsf-compliant-keybindings* t)


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
;         (function (lambda ()
; ;;                  (local-set-key [f8] 'eval-and-advance)
;                     )))


;; HyperSpec

(setq common-lisp-hyperspec-root
      "file:/usr/local/doc/HyperSpec/")
(setq common-lisp-hyperspec-symbol-table
      "/usr/local/doc/HyperSpec/Data/Map_Sym.txt")


;; CLtL2

(setq cltl2-root-url "file:/usr/local/doc/cltl2/")


;; Scheme mode

;;(setq scheme-program-name "scsh")

;;(setq cmuscheme-load-hook
;;      '((lambda () (define-key inferior-scheme-mode-map "\C-c\C-t"
;;                     'favorite-cmd))))

(set-default 'auto-mode-alist
             (append '(("\\.scm$" . scheme-mode)
                       ("\\.stk$" . scheme-mode)
                       ("\\.stklos$" . scheme-mode))
                     auto-mode-alist))


;; (add-to-list 'auto-mode-alist
;;              (mapcar (lambda (x) (cons x scheme-mode))
;;                      '("\\.scm$" "\\.ss$" "\\.stk$" "\\.stklos$")))

(add-hook 'scheme-mode-hook
          (lambda ()
            (require 'ilisp)
            (imenu-add-to-menubar "Functions")
            (font-lock-add-keywords
             nil
             '(("\\<\\(FIXME:.*\\)" 1 font-lock-warning-face t)))))


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

(setq TeX-pdf-mode t)                     ; generate PDF


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

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")


;; web mode

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))


;; Emacs server

;;(if (display-graphic-p)
;;  (server-start))


(global-set-key [f3] 'shell-other-window)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;;(add-hook 'mail-mode-hook 'turn-on-auto-fill)
;;(add-hook 'message-mode-hook 'turn-on-auto-fill)
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


(defun conditional-untabify ()
  "Untabify (or not) based on the major mode."
  (let ((modes-preserved '("Go"
                           "Makefile")))
    (unless (member mode-name modes-preserved)
      (untabify (point-min) (point-max)))))


(defun untabify-buffer-upon-save ()
  "Current buffer will be untabified prior to saving."
  (add-hook 'before-save-hook
            (lambda ()
              (untabify (point-min) (point-max))) nil t))


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


(defun open-in-browser()
  "Open current buffer in browser."
  (interactive)
  (let ((filename (buffer-file-name)))
    (browse-url (concat "file://" filename))))


;; startup

(let ((custom-file (expand-file-name "~/.emacs.custom.el")))
  (if (and (not (getenv "NOCUSTOM")) (file-exists-p custom-file))
      (load custom-file)))

(if (file-exists-p "~/.diary")
    (diary))

(cond ((getenv "START_AGENDA")
       (org-agenda-list)
       (switch-to-buffer "*Org Agenda*")
       (delete-other-windows)))


;;; Local Variables:
;;;   mode: outline-minor
;;; End:
