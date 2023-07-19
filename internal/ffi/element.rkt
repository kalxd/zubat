#lang azelf

(require "./util.rkt"
         "./primitive.rkt")

(provide (all-defined-out))

(define-ptr element_ref)

(define-golbat free-element-ref
  (_fun _element_ref_ptr -> _void)
  #:wrap (deallocator))

(define-golbat element-id
  (_fun _element_ref_ptr -> (_or-null _cstring_ptr))
  #:wrap (allocator free-cstring))

(define-golbat element-has-class
  (_fun _element_ref_ptr _string -> _bool))

(define-golbat element-attr
  (_fun _element_ref_ptr _string -> (_or-null _cstring_ptr))
  #:wrap (allocator free-cstring))
