	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;                           ;;;
	;;;  bies configuration file  ;;;
	;;;                           ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C-h v - describe variable
;; C-h f - describe function
;; M-x eval-buffer - evaluates all buffer as emacs script
;; M-x shell - for terminal
;; C-h k - to figure out what the bindings

;; magit package can be useful for managing git operations
(require 'package)
(setq package-archives
      '(
	("elpa" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
	("org" . "https://orgmode.org/elpa/")
	)
      )

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; for lsp
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(unless (package-installed-p 'gnu-elpa-keyring-update)
  (package-install 'gnu-elpa-keyring-update))

(unless (package-installed-p 'csharp-mode)
  (package-install 'csharp-mode))
(require 'csharp-mode)
(use-package multiple-cursors)
(use-package ivy
  :diminish
  :config (ivy-mode 1))

;; M-x all-the-icons-install-fonts
(use-package all-the-icons)
;; nicer cmd && minibuffer panel
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 10)
  )

;;M-x load-theme
(use-package doom-themes
  :init (load-theme 'doom-one t)
  )

;; brackets highlighting
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3)
  )

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key)
  )

;;(use-package helm)

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    )
  )

(use-package lua-mode)

;; guide: https://jblevins.org/projects/markdown-mode/
;; git: https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

; (use-package yaml-mode)
; (require 'yaml-mode)
; (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(add-hook 'yaml-mode-hook
	  (lambda ()
	    (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;(lsp-install-server 'csharp)
;;(use-package csharp-mode
;;  :mode "\\.cs\\'"
;;  :hook (csharp-mode . lsp-deffered)
;;  :config (charp-mode-indent-level 2)
;;  )

;;need configure ac module
;;ac-menu-height
;;ac-stop-words

;; for c-sharp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   My functions                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun bies-marked-region-get()
  "This function gets marked region from (region-beginning) to (region-end)"
  (defvar beg nil)
  (defvar end nil)

  (setq beg (- (region-beginning) 1))
  (setq end (- (region-end) 1))

  (substring (buffer-string) beg end)
  )

(defun private-bies-search-selected(beg end)
  "This function search for selected text"
  (interactive)
  (let (
	(selection (buffer-substring-no-properties beg end))
	)
    (deactivate-mark)
    (isearch-mode t nil nil nil)
    (isearch-yank-string selection)
    )
  )

(defun bies-search()
  "More usefull search function"
  (interactive)
  (if (use-region-p)
      (private-bies-search-selected (region-beginning) (region-end))
    (isearch-forward)
    )
  )

(defun bies-duplicate-line()
  "This function duplicates current line"
  (interactive)
  (save-excursion
    (setq-local text (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
    (end-of-line)
    (newline)
    (insert text)
    )
  )

(defun private-bies-switch-to(name)
  "Switching to buffer or file if they exists"
  (interactive)
  (if (get-buffer name)
      (switch-to-buffer name)
    (when (file-exists-p name)
      (find-file name))
    )
  )

(defun bies-switch-to-source-or-header()
  "Switching between header and source files"
  (interactive)
  (setq ext (file-name-extension (buffer-name)))
  (setq base (file-name-base (buffer-name)))

  (when (equal ext "c")
    (setq-local header (concat base ".h"))
    (private-bies-switch-to header)
    )

  (when (equal ext "h")
    (setq-local source (concat base ".c"))
    (private-bies-switch-to source)
    )
  )

(defun bies-toggle-whitespace-mode()
  "Switching turn on or turn off global whitespace mode"
  (interactive)
  (if global-whitespace-mode
      (global-whitespace-mode 0)
    (global-whitespace-mode 1)
    )
  )

(defun bies-replace-symbol-at-point()
  (interactive)
  ;; (isearch-forward-symbol-at-point)
  ;; (cua-copy-region )
  ;; (clipboard-kill-ring-save (point-at-bol) (point-at-eol))
  ;; (replace-string "" "")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                End of My functions                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   Global stuff                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mods and Hooks
;; startup: turn off startup emacs page
(setq inhibit-startup-screen t)
;; Start window size
(menu-bar-mode 0)
;; toolbar: remove tool bar
(tool-bar-mode 0)
;; scroll-bar: remove scroll bar
(scroll-bar-mode -1)
;; (global-visual-line-mode t)
;; показать номер столбца в mode-line
(column-number-mode)
(cua-mode t)
;; Selection: удаляем выделенный текст набирание текста
(delete-selection-mode t)
;; File system watcher: C-x C-f now is much more usefull
(ido-mode 1)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Display line nubers
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))
  )

;; font settings
(set-face-attribute 'default nil
		    :family "Source Code Pro"
		    :height 165
		    :weight 'normal
		    :width 'normal)
;; Set frame position to right
(set-frame-size (selected-frame) 1110 1000 t)
(set-frame-position (selected-frame) 800 1)
;; Cursor: set cursor type to 'bar
(setq-default cursor-type 'bar)
;; Line wrapping
(setq-default word-wrap t)
;; same clipboard with OS
(setq x-select-enable-clipboard t)
;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)
;; Display the name of the current buffer in the title bar
(setq frame-title-format "%b")
;; вверх-вниз по 1 строке
(setq scroll-step 1)
;; сдвигать буфер верх/вниз когда курсор в 10 шагах от верхней/нижней границы
(setq scroll-margin 3)
;; отключить звуковой сигнал
(setq ring-bell-function 'ignore)
;; лучшая отрисовка буфера
(setq redisplay-dont-pause t)
;; Disable backup/autosave files
(setq-default make-backup-files        nil)
(setq-default auto-save-default        nil)
(setq-default auto-save-list-file-name nil)

;; автозакрытие {},[],() с переводом курсора внутрь скобок
(require 'electric)
(electric-pair-mode 1)
;; включить выделение {},[],()
(show-paren-mode t)
(setq search-highlight        t)
(setq query-replace-highlight t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     Keybindings                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    UNSET all key bindings i don't need     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cua base keybinding
(global-unset-key (kbd "C-f"))
(global-unset-key (kbd "C-b"))
(global-unset-key (kbd "C-n"))
(global-unset-key (kbd "C-p"))
(global-unset-key (kbd "C-a"))
(global-unset-key (kbd "C-w"))
(global-unset-key (kbd "C-q"))
(global-unset-key (kbd "C-d"))
(global-unset-key (kbd "C-s"))
(global-unset-key (kbd "C-u"))
(global-unset-key (kbd "C-x C-q"))
(global-unset-key (kbd "C-x C-z"))
(global-unset-key (kbd "C-x <left>"))
(global-unset-key (kbd "C-x <right>"))
(global-unset-key (kbd "C-x d"))

(global-unset-key (kbd "<S-delete>"))
(global-unset-key (kbd "<S-enter>"))

(global-unset-key (kbd "M-z"))
(global-unset-key (kbd "M-h"))

(global-unset-key (kbd "<f1>"))
(global-unset-key (kbd "<f2>"))
(global-unset-key (kbd "<f3>"))
(global-unset-key (kbd "<f4>"))
(global-unset-key (kbd "<f5>"))
(global-unset-key (kbd "<f6>"))
(global-unset-key (kbd "<f7>"))
(global-unset-key (kbd "<f8>"))
(global-unset-key (kbd "<f9>"))
(global-unset-key (kbd "<f10>"))
(global-unset-key (kbd "<f11>"))
(global-unset-key (kbd "<f12>"))



;;(global-unset-key [mouse-1])
;;(global-unset-key [mouse-3])
;;(global-unset-key (kbd "<C-mouse-1>"))
;;(global-unset-key (kbd "<S-mouse-3>"))

;; unset C-numpad, make it for C-down in vs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     SET all key bindings i don't need      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; F buttons
(global-set-key (kbd "<f1>") 'bies-toggle-whitespace-mode)
(global-set-key (kbd "<f2>") 'ivy-switch-buffer)
(global-set-key (kbd "<f5>") 'isearch-forward-symbol-at-point)
(global-set-key (kbd "<f9>") 'bies-replace-symbol-at-point)

;;C-x SPC rectangle selective mode
(global-set-key (kbd "C-s") 'bies-search)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
;; (global-set-key (kbd "C-w") 'beginning-of-visual-line)
(global-set-key (kbd "C-q") 'kill-whole-line)
(global-set-key (kbd "C-d") 'bies-duplicate-line)

(global-set-key (kbd "C-x d") 'delete-window)
(global-set-key (kbd "C-x <up>") 'delete-other-windows)
(global-set-key (kbd "C-x h") 'split-window-below)
(global-set-key (kbd "C-x v") 'split-window-right)
(global-set-key (kbd "C-x <right>") 'other-window)

;; MAKE MOUSE GREAT AGAIN
;; on Linux, make Control+wheel do increase/decrease font size
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

;; Easy transition between buffers: M-arrow-keys
(global-set-key (kbd "M-h") 'suspend-frame)
;; multiple cursors set up
(global-set-key (kbd "<M-up>") 'mc/mark-previous-like-this)
(global-set-key (kbd "<M-down>") 'mc/mark-next-like-this)
;;switch buffer
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)
(setq mouse-wheel-progressive-speed nil)

;; Emacs Lisp Mode
(define-key emacs-lisp-mode-map (kbd "<f9>") 'eval-buffer)

;; C Mode
(require 'cc-mode)
(define-key c-mode-map (kbd "C-d") 'bies-duplicate-line)
(define-key c-mode-map (kbd "<f4>") 'bies-switch-to-source-or-header)

;; Markdown mode
;; (require 'markdown-mode)
;;(define-key markdown-map (kbd "<f1>") 'markdown-preview)
;;(eval-after-load 'markdown-mode '(define-key markdown-map [(kbd "<f1>")] 'markdown-preview))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   End of keybindings                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;C MODE
;; c mode by default
(setq default-major-mode 'c-mode)
;; auto fill
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;;;;;;;;;;
;; Base ;;
;;;;;;;;;;
;; Clipboard settings
;; coding
(set-language-environment 'UTF-8)
;; для GNU/Linux кодировка utf-8
(progn
  (setq default-buffer-file-coding-system 'utf-8)
  (setq-default coding-system-for-read    'utf-8)
  (setq file-name-coding-system           'utf-8)
  (set-selection-coding-system            'utf-8)
  (set-keyboard-coding-system        'utf-8-unix)
  (set-terminal-coding-system             'utf-8)
  (prefer-coding-system                   'utf-8))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 END OF GLOBAL STUFF                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; ;;;;;; ;;
;; FRAMES ;;
;; ;;;;;; ;;


;;additional links
;; addtionla functions
;; https://habr.com/en/post/265531/



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 Programming language package                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; programming: Imenu
;;(require 'imenu)
;;(setq imenu-auto-rescan      t) ;; автоматически обновлять список функций в буфере
;;(setq imenu-use-popup-menu nil) ;; диалоги Imenu только в минибуфере
;;(global-set-key (kbd "<f6>") 'imenu) ;; вызов Imenu на F6

;;;;;;;;;;;;;;;;;;;;;;;
;; Highlighting stuf ;;
;;;;;;;;;;;;;;;;;;;;;;;
;; Electric-modes settings
;;(electric-indent-mode 1) ;; включить индентацию  electric-indent-mod'ом (default in Emacs-24.4)

;; Indent settings (linux style (good one))
(setq-default c-basic-offset 4)
(setq c-default-style "linux"
      c-basic-offset 4)

;; выделить цветом выражения между {},[],()
					;(setq show-paren-style 'expression)

;;;;;;;;;;;;;;;;;;
;; Full Package ;;
;;;;;;;;;;;;;;;;;;
;; C/C++/Java
;; CEDET settings
;; (require 'cedet) ;; использую "вшитую" версию CEDET.
;; (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)

;;(require 'ede/generic)
;;(require 'semantic/ia)
;;(semantic-mode   t)
;;(global-ede-mode t)
;;(ede-enable-generic-projects)

	    ;;;;;;;;;;;;;;;
;; FOR CODER ;;
	       ;;;;;;;;;;;;;;;
;;(load-theme 'deeper-blue)
;;(load-theme 'wombat)


;;(add-hook 'c-mode-common-hook '(lambda ()
;;
;;	;; to begin completion when you type in a . or a ->
;;	(add-to-list 'ac-omni-completion-sources
;;				 (cons "\\." '(ac-source-semantic)))
;;	(add-to-list 'ac-omni-completion-sources
;;				 (cons "->" '(ac-source-semantic)))
;;
;;	;; ac-sources was also made buffer local in new versions of
;;	;; autocomplete.  In my case, I want AutoComplete to use
;;	;; semantic and yasnippet (order matters, if reversed snippets
;;	;; will appear before semantic tag completions).
;;
;;	(setq ac-sources '(ac-source-semantic ac-source-yasnippet))
;;))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              End of Programming language package             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;;lisp
;;

;; (global-unset-key (kbd "C-s"))
;; (global-set-key (kbd "C-s") 'search-forward)

;;(buffer-substring beg end)


;; print system name
;; (system-name)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; little doc for emacs lisp ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;
;;
;;
;;
;;
;; progn - это функция которая заставляет, чтобы каждый из ее аргументов последовательно был вычислен и затем возвращает значение последнего вычисленного выражения. Предыдущие выражения вычисляются только ради побочных эффекты, которые они производят. Значения, которые они возвращают теряются.
;; Example:
;; (progn body...)
;;
;; nthcdr - функция, котоая удаляется n-ое значение из списка
;; (nthcdr 1 '("value1" "value2" "value3"))
;;
;; car - функция, которая берет 1 элемент списка
;; (car 1 '("value1" "value2" "value3"))
;;
;; cons - функция, добовляет элемент в список
;; (cons "другой блок" '("блок текста" "последний блок"))
;;
;; message - функция, выводит сообщение на экран, принимает форматированную строку
;;
;; operators:
;;
;; +: (+ 1 2)
;; -: (- 2 3)
;; *: (* 6 7)
;; /: (/ 6 3)
;; %: (% 6 4)
;; >: (> 6 3)
;; <: (< 6 3)

;; if: (if (> 5 4))
;; Example: (if (> 5 4) (message "5 > 4"))
;; if-else: (if (> 5 8) (message "5 > 8") (message "else 5 < 8")) (if 4 "истина" "ложь")
;;
;; MOUSE KEYS
;;
;; mouse-1 (Left button)
;; mouse-2 (Wheel button click / Middle button)
;; mouse-3 (Right button)
;; mouse-4 (Wheel up)
;; mouse-5 (Wheel down)
;;
;;(defun current-symbols() (- (point) (point-min) 1))
;;(current-symbols)
;;select whole buffer C-a
;;(mark-whole-buffer)

;; (defun documented-function-example() "Docs for func")
;; (documented-function-example)
;; (defun interactive-function-we-can-bind-to-key() (interactive))
;; (interactive-function-we-can-bind-to-key)
;; equal: (equal 2 2) (equal "one" "one")
;;

;;(insert (propertize "foo" 'font-lock-face '(:foreground "red")))
;;(insert "\n");;

;;
;;
;;
;;
;;
;;
;;
;;
;;
;;
;;
;;

;; Cursor: set cursor type to 'bar
;;(setq-default cursor-type 'bar)
;; cursor: set cursor type to 'box
;; (setq cursor-type 'box)
;; cursor: set cursor type to nil
;; (setq cursor-type 'nil)
;; cursor: set cursor type to
;; (setq cursor-type 'hollow)
;; cursor: set cursor type to
;; (setq cursor-type '(bar . 1))
;; cursor: set cursor type to
;; (setq cursor-type 'hbar)
;; cursor: set cursor type to
;; setq cursor-type '(hbar . 10))
					;(require 'bs)
					;(require 'ibuffer)
;; отдельный список буферов при нажатии C-x C-b
					;(defalias 'list-buffers 'ibuffer)
;; запуск buffer selection кнопкой F2
;;(global-set-key (kbd "<f2>") 'bs-show)

;;;; вызвать Linum
;;(require 'linum)
;; показать номер строки в mode-line
;;(line-number-mode   t)
;; показывать номера строк во всех буферах
;;(global-linum-mode  t)

;; задаем формат нумерации строк
;;(setq linum-format "%d")
;; органичиталь текста только слева
					;(fringe-mode '(4  0))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#282c34" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF" "#bbc2cf"])
 '(custom-safe-themes
   '("2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" default))
 '(fci-rule-color "#5B6268")
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(objed-cursor-color "#ff6c6b")
 '(package-selected-packages
   '(yaml-mode charp-mode csharp-mode gnu-elpa-keyring-update lsp-mode lua-mode emacs-async helm doom-themes helpful counsel ivy-rich rainbow-delimiters doom-modeline multiple-cursors ivy use-package))
 '(pdf-view-midnight-colors (cons "#bbc2cf" "#282c34"))
 '(rustic-ansi-faces
   ["#282c34" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF" "#bbc2cf"])
 '(vc-annotate-background "#282c34")
 '(vc-annotate-color-map
   (list
    (cons 20 "#98be65")
    (cons 40 "#b4be6c")
    (cons 60 "#d0be73")
    (cons 80 "#ECBE7B")
    (cons 100 "#e6ab6a")
    (cons 120 "#e09859")
    (cons 140 "#da8548")
    (cons 160 "#d38079")
    (cons 180 "#cc7cab")
    (cons 200 "#c678dd")
    (cons 220 "#d974b7")
    (cons 240 "#ec7091")
    (cons 260 "#ff6c6b")
    (cons 280 "#cf6162")
    (cons 300 "#9f585a")
    (cons 320 "#6f4e52")
    (cons 340 "#5B6268")
    (cons 360 "#5B6268")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
