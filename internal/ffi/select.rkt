#lang azelf

(require "./util.rkt"
         "./element.rkt")

(provide (all-defined-out))

(define-ptr html_select)
(define-ptr element_select)

(define-golbat free-html-select
  (_fun _html_select_ptr -> _void)
  #:wrap (deallocator))

(define-golbat free-element-select
  (_fun _element_select_ptr -> _void)
  #:wrap (deallocator))

(define-golbat html-select-next
  (_fun _html_select_ptr -> (_or-null _element_ref_ptr))
  #:wrap (allocator free-element-ref))

(define-golbat element-select-next
  (_fun _element_select_ptr -> (_or-null _element_ref_ptr))
  #:wrap (allocator free-element-ref))
