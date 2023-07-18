#lang azelf

(require "./internal/html.rkt"
         "./internal/element.rkt")

(module+ main
  (require racket/file)
  (define x (file->string "./sample.html"))
  (define doc (string->html x))
  (monad/do
   (title <- (html-query1 "h2" doc))
   (! (displayln title))
   (id <- (element-id title))
   (! (displayln id))
   (Just 1)))
