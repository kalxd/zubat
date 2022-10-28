#lang azelf

(require ffi/unsafe
         ffi/unsafe/define
         (for-syntax racket/base
                     racket/syntax))

(define-syntax (define-pointer stx)
  (syntax-case stx ()
    [(_ name)
     (with-syntax ([name (format-id stx "~a-ptr*" #'name)])
         #'(define name (_cpointer 'name)))]))

(define-ffi-definer define-golbat
  (ffi-lib (expand-user-path "~/Workspace/XGLib/golbat/target/debug/libgolbat.so")))

;; css selector
(define-pointer selector)
(define-golbat build-selector
  (_fun _string -> selector-ptr*)
  #:c-id build_selector)

;; element parser
(define-pointer element)
(define-pointer element-iter)
(define-pointer element-text-iter)

(define-golbat element-name
  (_fun element-ptr* -> _string)
  #:c-id element_name)

(define-golbat element-select
  (_fun element-ptr* selector-ptr* -> element-iter-ptr*)
  #:c-id element_select)

(define-golbat element-id
  (_fun element-ptr* -> _string)
  #:c-id element_id)

(define-golbat element-html
  (_fun element-ptr* -> _string)
  #:c-id element_html)

(define-golbat element-inner-html
  (_fun element-ptr* -> _string)
  #:c-id element_inner_html)

(define-golbat element-text
  (_fun element-ptr* -> element-text-iter-ptr*)
  #:c-id element_text)

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

(module+ test
  (define html-doc
    "<!DOCTYPE html>
    <meta charset=\"utf-8\">
    <title>Hello, world!</title>
    <h1 class=\"foo\">Hello, <i>world!</i></h1>
<input placeholder=\"this is placeholder\">")

  (define fragment-doc
    "<h1>Hello, <i>world!</i></h1>")

  (define doc (parse-html html-doc))
  (define selector (build-selector "input"))
  (define iter (html-select doc selector))

  (define el (next-html-select iter))
  (displayln (element-name el))
  (displayln (next-html-select iter)))
