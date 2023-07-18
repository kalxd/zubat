#lang azelf

(require "./internal/html.rkt")

(module+ main
  (require racket/file)
  (define x (file->string "./sample.html"))
  (define doc (string->html x))
  (define doc- (html-query1 "h2" doc))
  (displayln doc-))
