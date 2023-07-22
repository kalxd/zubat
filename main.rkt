#lang azelf

(export-from "./internal/html.rkt"
             "./internal/element.rkt")

(provide (all-defined-out))

(define/contract (query-by-id id doc)
  (-> string? Html? (Maybe/c Element?))
  (define selector (format "#~a" id))
  (html-query1 selector doc))

(module+ main
  (require racket/file)
  (define x (file->string "./sample.html"))
  (define doc (string->html x))
  (monad/do
   (title <- (html-query1 ".line862" doc))
   (! (displayln (element-class title)))
   (id <- (element-id title))
   (! (displayln id))
   (Just 1)))
