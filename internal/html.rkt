#lang azelf

(require "./ffi/html.rkt"
         "./ffi/selector.rkt")

(provide (all-defined-out))

(struct Html [ptr])
(struct Select [ptr])

(define/contract string->html
  (-> string? Html?)
  (>-> parse-html Html))

(define/contract string->fragment
  (-> string? Html?)
  (>-> parse-fragment Html))

(define/curry/contract (html-query selector doc)
  (-> string? Html? Select?)
  (define selector-ptr (build-selector selector))
  (->> (Html-ptr doc)
       (html-select it selector-ptr)
       Select))
