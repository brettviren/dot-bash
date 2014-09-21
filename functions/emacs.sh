function org-capture {
    emacsclient -t -e "(progn (org-capture) (delete-frame))"
}
