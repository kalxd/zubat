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

                         (a (@ (class "item") (href "href1")) "item 1")
                         (a (@ (class "item") (href "href2")) "item 2"))
                    (div (@ (class "main body") (id "body"))

                         (p "text")))))

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

;; 是否有子元素
(define/contract zubat:child?
  (-> sxml:element? boolean?)
  (compose not
           empty?
           zubat:children))

(module+ test
  (test-case "zubat:child?"
    (check-true (zubat:child? el))
    (let ([el1 '(main)]
          [el2 '(a (@ (href "link")))])
      (check-false (zubat:child? el1))
      (check-false (zubat:child? el2)))))

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

;; 所有子元素
(define/contract (zubat:all el)
  (-> sxml:element? nodeset?)
  (foldl (λ (el xs)
           (define children (zubat:all el))
           (append xs (cons el children)))
         empty
         (zubat:children el)))

(module+ test
  (test-case "zubat:all"
    (check-length 5 (zubat:all el))
    (let ([el1 '(div (p) (p))]
          [el2 '(div)]
          [el3 '(div (div (div) (div)) (div))])
      (check-length 2 (zubat:all el1))
      (check-length 0 (zubat:all el2))
      (check-length 4 (zubat:all el3)))))

;; 过滤元素
(define/contract (zubat:select f el)
  (-> (-> sxml:element? boolean?)
      sxml:element?
      (listof sxml:element?))
  (filter f (zubat:all el)))

(module+ test
  (define (select-class2 el)
    (= 2 (length (zubat:class el))))

  (test-case "zubat:select"
    (check-length 2 (zubat:select select-class2 el))
    (check-length 2 (zubat:select (λ (el)
                                    (equal? '("item") (zubat:class el)))
                                  el))
    (check-length 1 (zubat:select (λ (el)
                                    (equal? "p" (zubat:tag el)))
                                  el))))

;; 过滤到第一个元素
(define/contract (zubat:select-first f el)
  (-> (-> sxml:element? boolean?)
      sxml:element?
      (maybe/c sxml:element?))
  (safe-head (zubat:select f el)))

(module+ test
  (test-case "zubat:select-first"
    (check-equal? "nav"
                  (zubat:tag (zubat:select-first select-class2
                                                 el)))
    (let ([nav-el (zubat:select-first (λ (el)
                                        (equal? "a" (zubat:tag el)))
                                      el)])
      (check-equal? "href1" (zubat:attr 'href nav-el))
      (check-equal? "item 1" (zubat:text nav-el)))))
