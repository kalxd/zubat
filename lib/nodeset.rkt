#lang racket/base

(provide html/find-by-id)

(require racket/contract

         sxml

         "type.rkt"
         "node.rkt")

(module+ test
  (require rackunit)

  (define el '(main (@ (id "main"))
                    "hehe"

                    (nav (@ (class "nav bar"))

                         (a (@ (class "item") "item 1"))
                         (a (@ (class "item") "item 2")))
                    (div (@ (class "main body") (id "body"))

                         (p "text"))))
  )

(define/contract (id-equal? id el)
  (-> string? sxml:element? boolean?)
  (equal? id (html/attr 'id el)))

;; 按id查询
(define/contract (html/find-by-id id el)
  (-> string? sxml:element? (maybe/c sxml:element?))
  (define find-by-id
    (select-first-kid (λ (el) (displayln (sxml:element? el)) (id-equal? id el))))
  (find-by-id el))

(module+ test
  (test-case "html/find-by-id"
    (check-equal? el (html/find-by-id "main" el)))
  )
