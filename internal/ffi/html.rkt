#lang azelf

(require "./util.rkt"
         "./selector.rkt")

(provide (all-defined-out))

(define-ptr html)
(define-ptr select)

(define-golbat free-html
  (_fun _html_ptr -> _void)
  #:wrap (deallocator))

(define-golbat free-select
  (_fun _select_ptr -> _void)
  #:wrap (deallocator))

(define-golbat parse-html
  (_fun _string -> _html_ptr)
  #:wrap (allocator free-html))

(define-golbat parse-fragment
  (_fun _string -> _html_ptr)
  #:wrap (allocator free-html))

(define-golbat html-select
  (_fun _html_ptr _selector_ptr -> _select_ptr)
  #:wrap (allocator free-select))
