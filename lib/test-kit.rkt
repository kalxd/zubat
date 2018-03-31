#lang racket/base

(provide (all-defined-out)
         (all-from-out rackunit))

(require rackunit
         racket/list)

(define-simple-check (check-empty? v)
  (empty? v))

(define-simple-check (check-length n xs)
  (equal? n (length xs)))
