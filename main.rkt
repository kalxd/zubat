#lang azelf

(require html-parsing)

(define testing-file "./compiled/test.html")

(define p (open-input-file testing-file))
(define doc (html->xexp p))
