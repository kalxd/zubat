#lang azelf

(require "./internal/html.rkt"
         "./internal/element.rkt")

(define/contract (query-by-id id doc)
  (-> string? Html? (Maybe/c Element?))
  (define selector (format "#~a" id))
  (html-query1 selector doc))

(module+ main
  (require racket/file)
  (define x (file->string "./sample.html"))
  (define doc (string->html x))
  (monad/do
   (title <- (query-by-id "line-9" doc))
   (! (displayln (element-attr "id" title)))
   (id <- (element-id title))
   (! (displayln id))
   (Just 1)))
