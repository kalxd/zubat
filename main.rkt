#lang racket/base

(provide (all-from-out "./zubat/node.rkt")
         (all-from-out "./zubat/nodeset.rkt")
         (all-defined-out))

(require racket/contract
         racket/file
         html-parsing
         sxml
         "./zubat/node.rkt"
         "./zubat/nodeset.rkt")

(define/contract input-port->sxml
  (-> input-port? sxml:element?)
  html->xexp)

(define/contract (file->sxml path)
  (-> path-string? sxml:element?)
  (let ([text (file->string path #:mode 'text)])
    (html->xexp text)))
