#lang racket/base

(provide html/find-by-id)

(require racket/contract
         racket/list

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

;; 子元素列表
(define/contract html/children
  (-> (or/c empty? sxml:element?) nodeset?)
  (sxml:child sxml:element?))

(module+ test
  (test-case "html/children"
    (check-equal? 2
                  (length (html/children el)))
    (let ([el1 '(div (p) (p) (p))]
          [el2 '(div)])
      (check-equal? 3 (length (html/children el1)) "三个元素")
      (check-equal? 0 (length (html/children el2)) "单个元素")))
    )

(define/contract (id-equal? id el)
  (-> string? sxml:element? boolean?)
  (equal? id (html/attr 'id el)))

;; 第一个子元素
(define/contract html/child
  (-> (or/c empty? sxml:element?) (maybe/c sxml:element?))
  (compose safe-head html/children))

(module+ test
  (test-case "html/child"
    (check-equal? "nav bar" (html/attr 'class (html/child el)))
    (let ([empty-el '()]
          [el1 '(div (p))])
      (check-equal? #f (html/child empty-el))
      (check-equal? 'p (sxml:element-name (html/child el1))))))

;; 按id查询
(define/contract (html/find-by-id id el)
  (-> string? sxml:element? (maybe/c sxml:element?))
  (define find-by-id
    (select-first-kid (λ (el) (displayln (sxml:element? el)) (id-equal? id el))))
  (find-by-id el))
