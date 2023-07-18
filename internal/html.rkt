#lang azelf

(require (only-in ffi/unsafe ctype?)
         "./ffi/html.rkt"
         "./ffi/selector.rkt"
         "./select.rkt"
         "./element.rkt")

(provide (all-defined-out))

(struct Html [ptr])

(define/contract string->html
  (-> string? Html?)
  (>-> parse-html Html))

(define/contract string->fragment
  (-> string? Html?)
  (>-> parse-fragment Html))

(define/curry/contract (html-query selector doc)
  (-> string? Html? (Array/c ElementRef?))
  (define selector-ptr (build-selector selector))
  (->> (Html-ptr doc)
       (html-select it selector-ptr)
       html-select->array))

(define/curry/contract (html-query1 selector doc)
  (-> string? Html? (Maybe/c ElementRef?))
  (define selector-ptr (build-selector selector))
  (->> (Html-ptr doc)
       (html-select it selector-ptr)
       try/html-select-next))
