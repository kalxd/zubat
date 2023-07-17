#lang azelf

(require "./util.rkt")

(provide (all-defined-out))

(define-ptr element_ref)

(define-golbat free-element-ref
  (_fun _element_ref_ptr -> _void)
  #:wrap (deallocator))
