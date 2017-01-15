;;; Environment
(set-frame-parameter nil 'alpha 100)
(ggtags-mode   0)
(flyspell-mode 0)
(remove-hook 'prog-mode-hook #'ivan/maybe-enable-ggtags)
(remove-hook 'prog-mode-hook #'flyspell-prog-mode)

;;; Dependencies
(add-to-list 'load-path default-directory)
(require 'refactoring-demo-framework)
(require 'refactoring-step-kmacros)

(refactor-init)
