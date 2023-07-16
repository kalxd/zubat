#lang azelf

(require "./util.rkt")

(provide (all-defined-out))

(define-ptr selector)

(define-golbat free-selector
  (_fun _selector_ptr -> _void)
  #:wrap (deallocator))

(define-golbat build-selector
  (_fun _string -> _selector_ptr)
  #:wrap (allocator free-selector))
