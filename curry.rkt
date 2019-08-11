#lang racket/base

(require (prefix-in zubat: "main.rkt")
         racket/function)

(provide (except-out (all-defined-out)
                     swap-curry))

(define (swap-curry f)
  (curry (λ (v1 v2)
           (f v2 v1))))

(define input-port->sxml zubat:input-port->sxml)

(define file->sxml zubat:file->sxml)

(define node-attr (swap-curry zubat:node-attr))

(define node-attr? (swap-curry zubat:node-attr?))

(define node-text zubat:node-text)

(define node-tag-name zubat:node-tag-name)

(define node-id zubat:node-id)

(define node-class zubat:node-class)

(define node-class? (swap-curry zubat:node-class?))

(define node-children zubat:node-children)

(define node-children? zubat:node-children?)

(define node-child zubat:node-child)

(define node-all-children zubat:node-children)

(define node-select (swap-curry zubat:node-select))

(define node-select-first (swap-curry zubat:node-select-first))

(define node-select-id (swap-curry zubat:node-select-id))
