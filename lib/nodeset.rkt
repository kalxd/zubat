#lang racket/base

(provide (all-defined-out))

(require racket/contract
         racket/list

         sxml

         "type.rkt"
         "node.rkt")

(module+ test
  (require "test-kit.rkt")

  (define el '(main (@ (id "main"))
                    "hehe"

                    (nav (@ (class "nav bar"))

                         (a (@ (class "item") "item 1"))
                         (a (@ (class "item") "item 2")))
                    (div (@ (class "main body") (id "body"))

                         (p "text"))))
  )

;; 子元素列表
(define/contract zubat:children
  (-> (or/c empty? sxml:element?) nodeset?)
  (sxml:child sxml:element?))

(module+ test
  (test-case "zubat:children"
    (check-equal? 2
                  (length (zubat:children el)))
    (let ([el1 '(div (p) (p) (p))]
          [el2 '(div)])
      (check-length 3 (zubat:children el1) "三个元素")
      (check-length 0 (zubat:children el2) "单个元素"))))

;; 第一个子元素
(define/contract zubat:child
  (-> (or/c empty? sxml:element?) (maybe/c sxml:element?))
  (compose safe-head zubat:children))

(module+ test
  (test-case "zubat:child"
    (check-equal? "nav bar" (zubat:attr 'class (zubat:child el)))
    (let ([empty-el '()]
          [el1 '(div (p))])
      (check-equal? #f (zubat:child empty-el))
      (check-equal? 'p (sxml:element-name (zubat:child el1))))))

;; 过滤元素
(define/contract (zubat:select f el)
  (-> (-> sxml:element? boolean?)
      sxml:element?
      (listof sxml:element?))
  (filter f (zubat:children el)))

(module+ test
  (define (select-class2 el)
    (= 2 (length (zubat:class el))))

  (test-case "zubat:select"
    (check-length 2 (zubat:select select-class2 el))))
