#lang azelf

(require "./util.rkt")

(provide (all-defined-out))

(define-ptr element)

(define-golbat free-element
  (_fun _element_ptr -> _void)
  #:wrap (deallocator))
