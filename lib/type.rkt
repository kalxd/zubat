#lang racket/base

(provide maybe/c)

(require racket/contract)

(define (maybe/c c)
  (or/c #f c))
