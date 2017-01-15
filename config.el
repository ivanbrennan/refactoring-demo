;;; Environment
(set-frame-parameter nil 'alpha 100)
(setq kmacro-ring-max 128)
(remove-hook 'prog-mode-hook #'ivan/maybe-enable-ggtags)
(ggtags-mode   0)
(flyspell-mode 0)

;;; Dependencies
(load-file "macros.el")

;;; Keybindings
(bind-map-set-keys ivan/leader-map
  "i" #'refactor-select-refactoring)
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

(defun refactor-select-refactoring (ref)
  (interactive (list (completing-read "Select a refactoring: " refactor-refactorings)))
  (refactor-reset)
  (setq refactor-refactoring ref
        refactor--steps (refactor--get-steps ref)))

(defun refactor-reset ()
  (interactive)
  (erase-buffer)
  (setq refactor--index 0))

(defun refactor--get-steps (ref)
  (apropos-internal (format "^refactor-%s-[[:digit:]]+" ref) 'commandp))

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
