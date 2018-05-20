#lang racket/base

(provide zubat:children
         zubat:child?
         zubat:child
         zubat:all
         zubat:select
         zubat:select-first
         zubat:select-id
         zubat:parent
         zubat:ancestor)

(require racket/contract
         racket/list
         racket/function

         sxml

         "type.rkt"
         "node.rkt")

(module+ test
  (require "test-kit.rkt")

  (define-simple-check (check-tag? name el)
    (equal? name (zubat:tag el)))

  (define el '(main (@ (id "main"))
                    "hehe"
                    (nav (@ (class "nav bar"))
                         (a (@ (class "item") (href "href1")) "item 1")
                         (a (@ (class "item") (href "href2")) "item 2")
                         (a (@ (class "item") (href "href3")) "item 3"))
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
    (check-length 6 (zubat:all el))
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
    (check-length 3 (zubat:select (λ (el)
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

(define/contract (zubat:select-id id el)
  (-> string? sxml:element? (maybe/c sxml:element?))
  (define (select-id el)
    (equal? (zubat:attr 'id el)
            id))
  (zubat:select-first select-id el))

(module+ test
  (test-case "zubat:select-id"
    (let ([body-el (zubat:select-id "body" el)]
          [nil-el (zubat:select-id "you-do-not-know-me" el)])
      (check-tag? "div" body-el)
      (check-false nil-el))))

;; 父一级元素
(define/contract (zubat:parent root el)
  (-> sxml:element? sxml:element? (maybe/c sxml:element?))
  (safe-head ((node-parent root) el)))

(module+ test
  (test-case "zubat:parent"
    (let ([div (zubat:select-id "body" el)]
          [a (zubat:select-first (λ (el) (equal? "a" (zubat:tag el))) el)])
      (check-tag? "main" (zubat:parent el div))
      (check-tag? "nav" (zubat:parent el a))
      (check-false (zubat:parent el el)))))

;; 父级元素
(define/contract (zubat:ancestor root el)
  (-> sxml:element? sxml:element? (listof sxml:element?))
  (((sxml:ancestor (const #t)) root) el))

(module+ test
  (test-case "zubar:ancestor"
    (let ([item (zubat:select-first (λ (el) (equal? "a" (zubat:tag el))) el)])
      (check-length 2 (zubat:ancestor el item))
     (check-equal? '("nav" "main") (map zubat:tag (zubat:ancestor el item))))))

;; 兄弟元素
(define/contract (zubat:siblings root el)
  (-> sxml:element? sxml:element? (listof sxml:element?))
  (define parent (zubat:parent root el))
  (filter (compose not
                   (node-eq? el))
          (zubat:children parent)))

(module+ test
  (test-case "zubar:siblings"
    (let* ([nav (zubat:child el)]
           [sib-ls (zubat:siblings el nav)]
           [next-el (list-ref sib-ls 0)])
      (check-length 1 sib-ls)
      (check-tag? "div" next-el))))
