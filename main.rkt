#lang azelf

(require ffi/unsafe
         ffi/unsafe/define)


(define-ffi-definer define-golbat
  (ffi-lib (expand-user-path "~/Workspace/XGLib/golbat/target/debug/libgolbat.so")))

(define html-string
  "<ul>
        <li>Foo</li>
        <li>Bar</li>
        <li>Baz</li>
    </ul>")

(define _html_ptr (_cpointer 'html-ptr))
(define _selector_ptr (_cpointer 'selector-ptr))
(define _select_ptr (_cpointer 'select-ptr))
(define _element_ref_ptr (_cpointer 'element-ref-ptr))

(define-golbat parse-fragment
  (_fun _string -> _html_ptr)
  #:c-id parse_fragment)

(define-golbat build-select
  (_fun _string -> _selector_ptr)
  #:c-id build_select)

(define-golbat select
  (_fun _html_ptr _selector_ptr -> _select_ptr))

(define-golbat next-select
  (_fun _select_ptr -> (_or-null _element_ref_ptr))
  #:c-id next_select)

(define-golbat element-html
  (_fun _element_ref_ptr -> _string)
  #:c-id element_html)

(module+ main
  (define html (parse-fragment html-string))
  (define selector (build-select "ul > li:first-child"))
  (define iter (select html selector))

  (displayln iter)
  (define el1 (next-select iter))
  (displayln (element-html el1))
  (displayln iter)
  (define el2 (next-select iter))
  (displayln el2))
