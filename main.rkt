#lang azelf

(require xml html)

(define testing-file "./compiled/test.html")

(define my-xml
  (read-xhtml (open-input-file testing-file)))
