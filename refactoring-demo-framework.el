;;; Keybindings
(bind-keys
 ("M-]" . refactor-step-forward)
 ("M-[" . refactor-reset))

;;; Refactorings
(defconst refactor-refactorings '(move-method
                                  move-field
                                  extract-class
                                  inline-class
                                  hide-delegate
                                  remove-middle-man))

;;; Selector
(defcustom refactor-refactoring nil
  "The refactoring to demo."
  :options refactor-refactorings)

(defvar-local refactor--steps nil)
(defvar-local refactor--index 0)

(defun refactor-init ()
  (erase-buffer)
  (let* ((ref   (refactor--get-refactoring))
         (steps (refactor--get-steps ref)))
    (setq
     refactor-refactoring ref
     refactor--steps steps)))

(defun refactor--get-refactoring ()
  (let* ((base-name (file-name-base buffer-file-name))
         (prefix "^[[:digit:]]+_")
         (name (replace-regexp-in-string prefix "" base-name)))
    (replace-regexp-in-string "_" "-" name)))

(defun refactor--get-steps (ref)
  (apropos-internal (format "^refactor-%s-[[:digit:]]+" ref) 'commandp))

(defun refactor-reset ()
  (interactive)
  (erase-buffer)
  (setq refactor--index 0))

;;; Step functions
(defun refactor-step-forward ()
  (interactive)
  (and (refactor--run-current-step)
       (refactor--increment-index)))

(defun refactor--run-current-step ()
  (let ((step-func (nth refactor--index refactor--steps)))
    (if step-func
        (and (funcall step-func) t)
      (message "%s: finished" refactor-refactoring)
      nil)))

(defun refactor--increment-index ()
  (setq refactor--index (1+ refactor--index)))

(provide 'refactoring-demo-framework)
