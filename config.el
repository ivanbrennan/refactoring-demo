;;; Environment
(set-frame-parameter nil 'alpha 100)
(remove-hook 'prog-mode-hook #'ivan/maybe-enable-ggtags)
(ggtags-mode   0)
(flyspell-mode 0)

;;; Dependencies
(load-file "macros.el")

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

(defun refactor-select-refactoring (ref)
  (interactive (list (completing-read "Select a refactoring: " refactor-refactorings)))
  (setq refactor-refactoring ref
        refactor--steps (refactor--get-steps ref))
  (refactor-reset))

(defun refactor--get-steps (ref)
  (apropos-internal (concat "^refactor-" ref "-[[:digit:]]+") 'commandp))

(defvar-local refactor--steps nil)
(defvar-local refactor--index 0)

;;; Step functions
(defun refactor-step-forward ()
  (interactive)
  (refactor--run-current-step)
  (refactor--increment-index))

(defun refactor--run-current-step ()
  (let ((func (nth refactor--index refactor--steps)))
    (if func
        (funcall func)
      (message "%s: finished" refactor-refactoring))))

(defun refactor--increment-index ()
  (setq refactor--index (1+ refactor--index)))

(defun refactor-reset ()
  (interactive)
  (erase-buffer)
  (setq refactor--index 0))

(bind-map-set-keys ivan/leader-map
  "u" #'refactor-select-refactoring)
(bind-keys
 ("M-]" . refactor-step-forward)
 ("M-[" . refactor-reset))
