#lang azelf

(require ffi/unsafe
         ffi/unsafe/define
         (for-syntax racket/base
                     racket/syntax))

(provide (all-defined-out))

(define-syntax (define-pointer stx)
  (syntax-case stx ()
    [(_ name)
     (with-syntax ([name (format-id stx "~a-ptr*" #'name)])
         #'(define name (_cpointer 'name)))]))

(define-ffi-definer define-golbat
  (ffi-lib "libgolbat.so"))

;; css selector
(define-pointer selector)
(define-golbat build-selector
  (_fun _string -> selector-ptr*)
  #:c-id build_selector)

;; element parser
(define-pointer element)
(define-pointer element-iter)
(define-pointer element-text-iter)
(define-pointer element-classes-iter)
(define-pointer element-attrs-iter)

(define-cstruct _element-attr-tuple
  ([fst _string]
   [snd _string]))

(define-golbat element-select
  (_fun element-ptr* selector-ptr* -> element-iter-ptr*)
  #:c-id element_select)

(define-golbat next-element-select
  (_fun element-iter-ptr* -> (_or-null element-ptr*))
  #:c-id next_element_select)

(define-golbat element-html
  (_fun element-ptr* -> _string)
  #:c-id element_html)

(define-golbat element-inner-html
  (_fun element-ptr* -> _string)
  #:c-id element_inner_html)

(define-golbat element-text
  (_fun element-ptr* -> element-text-iter-ptr*)
  #:c-id element_text)

(define-golbat next-element-text
  (_fun element-text-iter-ptr* -> _string)
  #:c-id next_element_text)

(define-golbat element-name
  (_fun element-ptr* -> _string)
  #:c-id element_name)

(define-golbat element-id
  (_fun element-ptr* -> _string)
  #:c-id element_id)

(define-golbat element-classes
  (_fun element-ptr* -> element-classes-iter-ptr*)
  #:c-id element_classes)

(define-golbat next-element-classes
  (_fun element-classes-iter-ptr* -> _string)
  #:c-id next_element_classes)

(define-golbat element-attr
  (_fun element-ptr* _string -> _string)
  #:c-id element_attr)

(define-golbat element-attrs
  (_fun element-ptr* -> element-attrs-iter-ptr*)
  #:c-id element_attrs)

(define-golbat next-element-attrs
  (_fun element-attrs-iter-ptr* -> _element-attr-tuple-pointer/null)
  #:c-id next_element_attrs)

;; html parser
(define-pointer html)
(define-pointer html-iter)

(define-golbat parse-html
  (_fun _string -> html-ptr*)
  #:c-id parse_html)

(define-golbat parse-fragment
  (_fun _string -> html-ptr*)
  #:c-id parse_fragment)

(define-golbat html-select
  (_fun html-ptr* selector-ptr* -> html-iter-ptr*)
  #:c-id html_select)

(define-golbat next-html-select
  (_fun html-iter-ptr* -> (_or-null element-ptr*))
  #:c-id next_html_select)
