#lang racket/base

(provide maybe/c
         safe-head)

(require racket/contract
         racket/list)

(define (maybe/c c)
  (or/c #f c))

(define/contract (safe-head xs)
  (-> (listof any/c) (maybe/c any/c))
  (if (empty? xs) #f (first xs)))


(module+ test
  (require rackunit)
  (test-case "save-head"
    (check-equal? #f (safe-head '()))
    (check-equal? 1 (safe-head '(1 2)))
    (check-equal? 1 (safe-head (range 1 10)))))
