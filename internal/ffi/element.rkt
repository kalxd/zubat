#lang azelf

(require "./util.rkt"
         "./primitive.rkt"
         "./cstringpair.rkt")

(provide (all-defined-out))

(define-ptr element_ref)
(define-ptr attrs)

(define-golbat free-element-ref
  (_fun _element_ref_ptr -> _void)
  #:wrap (deallocator))

(define-golbat free-attrs
  (_fun _attrs_ptr -> _void)
  #:wrap (deallocator))

(define-golbat element-id
  (_fun _element_ref_ptr -> (_or-null _cstring_ptr))
  #:wrap (allocator free-cstring))

(define-golbat element-has-class
  (_fun _element_ref_ptr _string -> _bool))

(define-golbat element-attr
  (_fun _element_ref_ptr _string -> (_or-null _cstring_ptr))
  #:wrap (allocator free-cstring))

(define-golbat element-attrs
  (_fun _element_ref_ptr -> _attrs_ptr)
  #:wrap (allocator free-attrs))

(define-golbat element-attrs-next
  (_fun _attrs_ptr -> (_or-null _cstring_pair_ptr))
  #:wrap (allocator free-cstring-pair))

(define-golbat element-html
  (_fun _element_ref_ptr -> _cstring_ptr)
  #:wrap (allocator free-cstring-pair))

(define-golbat element-inner-html
  (_fun _element_ref_ptr -> _cstring_ptr)
  #:wrap (allocator free-cstring-pair))
