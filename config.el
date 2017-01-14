(set-frame-parameter nil 'alpha 100)
(load-file "macros.el")
(remove-hook 'prog-mode-hook #'ivan/maybe-enable-ggtags)
(ggtags-mode 0)

(defvar refactor-refactoring "move-method")

(defvar move-method--steps (mapcar
                            (lambda (i) (intern-soft (format "refactor-move-method-%d" i)))
                            (number-sequence 0 9)))
(defvar move-method--index 0)

(defun refactor-step-forward ()
  (interactive)
  (refactor--run-current-step "move-method")
  (refactor--increment-index  "move-method"))

(defun refactor--run-current-step (refactoring)
  (let ((func (refactor--current-step-func refactoring)))
    (if func
        (funcall func)
      (message "%s: finished" refactoring))))

(defun refactor--current-step-func (refactoring)
  (let* ((index (refactor--index-val  refactoring))
         (steps (refactor--step-funcs refactoring)))
    (nth index steps)))

(defun refactor--step-funcs (refactoring)
  (let* ((name (concat refactoring "--steps"))
         (sym  (intern-soft name)))
    (symbol-value sym)))

(defun refactor--increment-index (refactoring)
  (let ((sym (refactor--index-sym refactoring))
        (val (refactor--index-val refactoring)))
    (set sym (1+ val))))

(defun refactor--index-sym (refactoring)
  (intern-soft (concat refactoring "--index")))

(defun refactor--index-val (refactoring)
  (symbol-value (refactor--index-sym refactoring)))

(defun refactor-reset ()
  (interactive)
  (erase-buffer)
  (setq move-method--index 0))

(bind-keys
 ("M-]" . refactor-step-forward)
 ("M-[" . refactor-reset))
