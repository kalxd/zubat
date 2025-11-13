#lang azelf

(require "./type.rkt"
         (only-in "./element.rkt"
                  Element)
         racket/port)

(require/typed "./ffi/html.rkt"
  [parse-html (-> String CType)]
  [parse-fragment (-> String CType)]
  [html-select (-> CType CType CType)]
  [html-select-next (-> CType (Option CType))])

(require/typed "./ffi/selector.rkt"
  [build-selector (-> String CType)])

(provide Html
         string->html
         string->fragment
         input-port->html
         input-port->fragment
         html-query
         html-query1)

(struct Html ([ptr : CType]))

(: string->html (-> String Html))
(define (string->html input)
  (->> input parse-html Html))

(: string->fragment (-> String Html))
(define (string->fragment input)
  (->> input parse-fragment Html))

(: input-port->html (-> Input-Port Html))
(define (input-port->html p)
  (->> (port->string p)
       string->html))

(: input-port->fragment (-> Input-Port Html))
(define (input-port->fragment p)
  (->> (port->string p)
       string->fragment))

(: fold/html-query
   (-> CType (Listof Element) (Listof Element)))
(define (fold/html-query select-ptr acc)
  (define el-ptr (html-select-next select-ptr))
  (cond
    [(none? el-ptr) acc]
    [else (->> (Element el-ptr)
               (append acc (list it))
               (fold/html-query select-ptr it))]))

(: html-query (-> Html String (Listof Element)))
(define (html-query doc selector)
  (define selector-ptr (build-selector selector))
  (->> (Html-ptr doc)
       (html-select it selector-ptr)
       (fold/html-query it (list))))

(: html-query1 (-> Html String (Option Element)))
(define (html-query1 doc selector)
  (define selector-ptr (build-selector selector))
  (->> (Html-ptr doc)
       (html-select it selector-ptr)
       html-select-next
       (option/map it Element)))
