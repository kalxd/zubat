#lang azelf

(require "./util.rkt"
         "./primitive.rkt"
         "./selector.rkt"
         "./select.rkt"
         "./cstringpair.rkt")

(provide (all-defined-out))

(define-ptr element_ref)
(define-ptr attrs)
(define-ptr classes)

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

(define-golbat free-classes
  (_fun _classes_ptr -> _void)
  #:wrap (deallocator))

(define-golbat element-classes
  (_fun _element_ref_ptr -> _classes_ptr)
  #:wrap (allocator free-classes))

(define-golbat element-classes-next
  (_fun _classes_ptr -> (_or-null _cstring_ptr))
  #:wrap (allocator free-cstring))

(define-golbat element-select
  (_fun _selector_ptr -> _element_select_ptr)
  #:wrap (allocator free-element-select))

(define-golbat element-select-next
  (_fun _element_select_ptr -> (_or-null _element_ref_ptr))
  #:wrap (allocator free-element-ref))
