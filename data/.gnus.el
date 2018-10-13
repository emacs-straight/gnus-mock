;;; .gnus.el --- Settings for Gnus mock sessions  -*- lexical-binding:t -*-

;; Copyright (C) 2018  Free Software Foundation, Inc.

;; Do not edit this file, instead add further customizations to the
;; file indicated by `gnus-mock-gnus-file'.

(setq gnus-select-method
      `(nnmaildir
        "Test"
        (directory ,(file-name-as-directory
		     (expand-file-name "test" gnus-home-directory)))
	(get-new-mail nil)))

(setq user-mail-address "mockturtle@gnus.org"
      user-full-name "Mock Turtle")

;; `sendmail-program' has already been set to fakesendmail.py in the
;; init file.
(setq message-send-mail-function #'message-send-mail-with-sendmail)

(defun gnus-mock-reload ()
  "Restore the gnus mock data.
Restores all data in the mock data dir.  In some cases it might
work better simply to kill the mock Emacs process and start over
again."
  (interactive)
  (when (gnus-alive-p)
    (gnus-group-exit))
  (if (not gnus-mock-p)
      (message "Only use this command in a Gnus mock session")
    (when (y-or-n-p (format "Trash and restore %s? "
			    gnus-home-directory))
     (delete-directory gnus-home-directory t)
     (copy-directory gnus-mock-data-dir
		     gnus-home-directory nil nil t)
     (gnus-read-init-file)
     (message "Mock Gnus data restored"))))

(add-hook 'gnus-started-hook (lambda ()
			       (unless sendmail-program
				 (message "Python unavailable on this system, you won't be able to send mail"))))
