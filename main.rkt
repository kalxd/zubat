#lang azelf

(require "./internal/html.rkt"
         "./internal/element.rkt")

(provide (all-defined-out)
         (all-from-out "./internal/html.rkt"
                       "./internal/element.rkt"))

(define-type VNode
  (U Html Element))

(: query-by-id (-> VNode String (Option Element)))
(define (query-by-id node id)
  (define selector (format "#~a" id))
  (cond
    [(Html? node) (html-query1 node selector)]
    [else (element-query1 node selector)]))

(: query (-> VNode String (Listof Element)))
(define (query node selector)
  (cond
    [(Html? node) (html-query node selector)]
    [else (element-query node selector)]))

(: query1 (-> VNode String (Option Element)))
(define (query1 node selector)
  (cond
    [(Html? node) (html-query1 node selector)]
    [else (element-query1 node selector)]))
