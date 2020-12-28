#lang racket/base

(require racket/contract
         racket/function
         (for-syntax racket/base
                     racket/syntax))

;;; 结合racket/function、racket/contract，一口气同时两个函数。
;;; (define/curry (add x y) ..)
;;; 相当于定义了(define/contract (add x y) ...)及(define curry/add (curry add))
(define-syntax (define/curry stx)
  (syntax-case stx ()
    [(_ (name args ...) body ...)
     (with-syntax ([curry-name (format-id #'name "curry/~a" #'name)])
       #'(begin
           (define/contract (name args ...)
             body ...)
           (define curry-name (curry name))))]))

(module+ test
  (require "./test-kit.rkt")
  (define/curry (my-add x y)
    (-> positive? positive? positive?)
    (+ x y))

  (check-true (procedure? my-add))
  (check-equal? 2 (my-add 1 1))
  (check-equal? 10 ((curry/my-add 4) 6))
  (check-exn exn:fail:contract?
             (λ () (my-add -1 -2))))
