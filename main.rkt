#lang azelf

(export-from "./internal/html.rkt"
             "./internal/element.rkt")

(provide (all-defined-out))

(define/contract (query-by-id id doc)
  (-> string? Html? (Maybe/c Element?))
  (define selector (format "#~a" id))
  (html-query1 selector doc))

(define/curry/contract (query selector el)
  (-> string? (or/c Html? Element?) (Array/c Element?))
  (cond
    [(Html? el) (html-query selector el)]
    [else (element-query selector el)]))

(define/curry/contract (query1 selector el)
  (-> string? (or/c Html? Element?) (Maybe/c Element?))
  (cond
    [(Html? el) (html-query1 selector el)]
    [else (element-query1 selector el)]))
