#lang azelf

(require "./util.rkt"
         "./select.rkt"
         "./selector.rkt"
         "./element.rkt")

(provide (all-defined-out))

(define-ptr html)

(define-golbat free-html
  (_fun _html_ptr -> _void)
  #:wrap (deallocator))

(define-golbat parse-html
  (_fun _string -> _html_ptr)
  #:wrap (allocator free-html))

(define-golbat parse-fragment
  (_fun _string -> _html_ptr)
  #:wrap (allocator free-html))

(define-golbat html-select
  (_fun _html_ptr _selector_ptr -> _html_select_ptr)
  #:wrap (allocator free-html-select))

(define-golbat html-select-next
  (_fun _html_select_ptr -> (_or-null _element_ref_ptr))
  #:wrap (allocator free-element-ref))
