#lang racket/base

(provide file->sxml
         html->xexp)

(require racket/file
         racket/function
         racket/contract
         racket/list
         html-parsing
         sxml)

(module+ test
  (require rackunit)
  )

(define (maybe/c . cs)
  (apply or/c (cons #t cs)))

(define/contract (my-head xs)
  (-> list? (maybe/c string?))
  (if (empty? xs)
      #f
      (first xs)))

(define file->sxml
  (compose html->xexp
           (λ (path) (file->string path #:mode 'text))))

(define/contract (element/attr el attr)
  (-> sxml:element? symbol? (maybe/c string?))
  (define attr-list (sxml:attr-list el))
  (ormap (λ (p) (let ([k (first p)]
                      [v (last p)])
                  (and (equal? attr k) v)))
         attr-list))


(define doc (file->sxml "./file/sample.html"))

(define main-el (car ((sxpath '(// main)) doc)))
