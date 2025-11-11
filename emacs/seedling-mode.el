;; TODO
;; - the second {: shouldn't be interpreted as a paren
;;   {: {: ( -( heap )- )
;; - parens inside quoted strings shouldn't be interpreted as parens

(defgroup seedling nil
  "Major mode for editing Seedling source code."
  :group 'languages)

(defface seedling-operator-face
    '((t :inherit font-lock-builtin-face :weight bold))
  "Face used for operators in Seedling mode."
  :group 'seedling)

(defun seedling-syntax-propertize (start end)
  "Set syntax-table properties between START and END.

Backslashes are escape chars.
Double quotes are string quotes unless preceded by an exception keyword.
Single backslash followed by space marks a comment, but only outside strings.
Clears old syntax-table properties first."
  (save-excursion
    ;; clear old syntax-table props
    (remove-text-properties start end '(syntax-table nil))
    (goto-char start)
    (let ((exceptions '("ascii " "{: ")))
      (while (re-search-forward (rx (or (group (seq ?\\ (any space ?\n) (* any)))
                                        (group ?\\)
                                        (group ?\")))
                                end t)
        (cond
         ((match-beginning 1)
          ;; backslash-space: line comment start

          ;; FIXME: This simple rule assumes comments cannot appear inside
          ;; strings syntactically.
          ;; calling SYNTAX-PPSS to check whether we are inside a literal
          ;; string leads to an endless recursion:
          ;; (unless (nth 3 (syntax-ppss (match-beginning 1))) ...)

          ;; FIXME: a single \ and a newline colors the next line as comment
          (save-excursion
           (let ((pos (match-beginning 1)))
             ;; skip the definition of the comment word itself
             (unless (equal "{: " (buffer-substring-no-properties (max (point-at-bol)
                                                                       (- pos 3))
                                                                  pos))
               ;; or an alternative, equivalent condition:
               ;; (re-search-backward "{: " (max (point-at-bol) (- pos 3)) t)
               (put-text-property pos (1+ pos)
                                  'syntax-table (string-to-syntax "< b")) ; comment start
               ;; mark newline as comment end
               (save-excursion
                (when (re-search-forward "$" end t)
                  (put-text-property (point) (1+ (point))
                                     'syntax-table (string-to-syntax "> b"))))))))
         ((match-beginning 2)
          ;; Backslash → escape
          (put-text-property (match-beginning 2) (match-end 2)
                             'syntax-table (string-to-syntax "\\")))

         ((match-beginning 3)
          ;; Double quote → maybe string delimiter
          (let ((pos (match-beginning 3))
                (found nil))
            (dolist (kw exceptions)
              (let* ((len (length kw))
                     (before-start (max (point-min) (- pos len)))
                     (prefix (buffer-substring-no-properties before-start pos)))
                (when (string= prefix kw)
                  (setq found t)
                  (cl-return))))
            (if found
                (put-text-property pos (1+ pos) 'syntax-table nil)
                (put-text-property pos (1+ pos) 'syntax-table (string-to-syntax "\""))))))))))

(defvar seedling-font-lock-keywords
  `(
    ("[^-]\\(FIXME\\|TODO\\|KLUDGE\\|QUESTION\\|WARNING\\)"
     1 'font-lock-todo-face t)

    ;; Custom Seedling operators (override the keywords above)
    (,(regexp-opt '("dup" "drop" "swap" "over" "rot") 'words)
     (0 font-lock-builtin-face nil))

    ;; Keywords
    (,(regexp-opt
       '("0/" "0<" "0<>" "0>=" "0=" "1+" "1-"
         "<" "<=" "<>" "=" ">" ">="
         ">lit" ">lower" ">r" ">upper"

         "abs" "allot" "alphanum" "and" "ascii" "ask" "base"
         "bite" "bl" "bye" "c!" "c," "c@" "carry?" "catch"
         "cell+" "cell-" "cells" "constant" "context" "cr"
         "create" "current" "cut" "ddigit" "decimal"
         "definitions" "dictionary" "digit>int" "does"
         "dp" "drop" "du/mod" "dup" "effect" "emit"
         "endcomp" "endtail" "exception" "execute"
         "f." "f*" "f+" "f-" "f/" "f<" "f<=" "f<>" "f=" "f>"
         "f>int" "f>=" "f0<" "f0<>" "f0>=" "f0=" "fabs" "fbot"
         "ffrac" "fhalf" "finally" "find" "fint" "flog2" "fnegate"
         "frame" "ftop" "handle" "here" "hex" "immediate" "int>f"
         "invert" "input" "key" "last" "length" "letter" "link"
         "literal" "lower" "lshift" "mod" "negate" "nip" "nonempty"
         "or" "output" "over" "pad" "pfbot" "pftop" "postpone"
         "printable" "quotate" "r>" "r>drop" "reader" "rshift"
         "s." "s," "s<>" "s=" "s>number" "search" "space" "sprout"
         "sproutl" "swap" "third" "tib" "traverse&" "u*" "u/" "u/mod"
         "u<" "u<=" "u>" "u>=" "u8bite" "u8emit" "u8length" "u8key"
         "upper" "utf8" "variable" "vocabulary" "word" "write" "ws"
         "wsskip" "xor"

         "native" "times" "while")
       'words)
     . font-lock-keyword-face)

    (,(regexp-opt '(" @" " !"))
     (0 'seedling-operator-face t))

    ;; Match "{: word" or "native word"
    (,(rx
       (group (or "{:" "native"))       ; the definition keyword
       (+ space)                        ; one or more spaces
       ;; (group (+ (or word ?, ?- ?_ ?! ?+ ?* ?/ ?< ?> ?= ??))) ; the word name
       (group (+ (not space))) ; the word name
       )
     (2 font-lock-function-name-face nil))

    ;; Numbers (integer literals)
    ("\\b[0-9A-F]+\\b" (0 'font-lock-constant-face nil))

    ;; Stack effect comments (optional, like ( n1 n2 -- n3 ))
    ;;("(.*--.*)" . font-lock-comment-face)
    )
  "Highlighting expressions for Seedling mode.")

(defun seedling-indent-line ()
  "Indent current line for Seedling code."
  (interactive)
  (let ((indent-level 0)
        (not-indented t)
        (cur-line (thing-at-point 'line t)))
    ;; Simple rule: increase indent after ':' or 'if' or 'begin'
    (save-excursion
      (forward-line -1)
      (while (and not-indented (not (bobp)))
        (let ((prev-line (thing-at-point 'line t)))
          (cond
           ((string-match-p "\\(:\\|if\\|begin\\)" prev-line)
            (setq indent-level (+ (current-indentation) 2))
            (setq not-indented nil))
           ((string-match-p "\\(;\\|then\\|again\\|repeat\\)" prev-line)
            (setq indent-level (max 0 (- (current-indentation) 2)))
            (setq not-indented nil))
           (t
            (forward-line -1))))))
    (indent-line-to indent-level)))

(defvar seedling-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; ;; Everything is a word character by default.
    ;; (dotimes (i 256)
    ;;   (modify-syntax-entry i "w" st))

    ;; words can have any character between ! and ~
    (let ((c ?!))
      (while (<= c ?~)
        (modify-syntax-entry c "w" st)
        (cl-incf c)))

    ;; Space, tab, and newline are whitespace.
    ;; https://github.com/nagydani/seedling/blob/master/sprout/README.md#parsing
    (modify-syntax-entry ?\s " " st)
    (modify-syntax-entry ?\t " " st)
    (modify-syntax-entry ?\r " " st)
    (modify-syntax-entry ?\n " " st)

    (modify-syntax-entry ?{ "(" st)
    (modify-syntax-entry ?} ")" st)
    (modify-syntax-entry ?\( "(" st)
    (modify-syntax-entry ?\) ")" st)

    st)
  "Syntax table for `seedling-mode` where only space, tab, and newline are word boundaries.")

(define-derived-mode seedling-mode fundamental-mode "Seedling"
  "Major mode for editing files of the Seedling langauge family."
  :syntax-table seedling-mode-syntax-table

  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 8)
  (setq-local comment-start "\\ ")
  (setq-local comment-end "")
  ;; (setq right-margin-width 64) ; influences the display
  (setq-local fill-column 64)
  ;; (setq-local indent-line-function #'seedling-indent-line)
  ;; explicitly turn off inherited syntax highlighting from other modes
  ;; (setq-local font-lock-keywords nil)
  (setq-local font-lock-defaults '(seedling-font-lock-keywords))

  (setq-local syntax-propertize-function 'seedling-syntax-propertize)
  ;; Force an initial pass so existing buffer text gets correct properties.
  ;;(syntax-propertize (point-max))
  )

;; --- Custom key bindings ---
(define-key seedling-mode-map (kbd "M-<right>") 'forward-sexp)
(define-key seedling-mode-map (kbd "M-<left>") 'backward-sexp)
(define-key seedling-mode-map (kbd "M-<down>") 'down-list)
(define-key seedling-mode-map (kbd "M-<up>") 'backward-up-list)

(add-hook 'seedling-mode-hook 'display-fill-column-indicator-mode)

(add-to-list 'auto-mode-alist
             (cons (rx "." (or "seed" "sprout") string-end)
                   'seedling-mode))

(provide 'seedling-mode)
