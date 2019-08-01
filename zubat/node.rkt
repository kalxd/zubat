#lang racket/base

(require racket/contract
         racket/string
         racket/list
         sxml)

(provide (all-defined-out))

(module+ test
  (require "test-kit.rkt")
  (displayln "测试开始！")
  (define el '(main (@ (id "main-id")) "main text"))
  (define el1 '(div (@ (class "button")) "primary button"))
  (define el2 '(input (@ (class "input") (type "text")))))

;; 元素属性
(define/contract (node-attr el attr)
  (-> sxml:element? symbol? (or/c #f string?))
  (let ([attr (sxml:attr el attr)])
    (and attr (string-trim attr))))

(module+ test
  (test-case "node-attr"
    (check-equal? "main-id" (node-attr el 'id))
    (check-equal? "button" (node-attr el1 'class))
    (check-equal? #f (node-attr el 'class))
    (check-equal? "text" (node-attr el2 'type))
    (check-equal? #f (node-attr el2 'id))))

;; 是否有这个属性。
(define/contract (node-attr? el attr)
  (-> sxml:element? symbol? boolean?)
  (let ([value (node-attr el attr)])
    (and value #t)))

(module+ test
  (test-case "node-attr?"
    (check-true (node-attr? el 'id))
    (check-false (node-attr? el 'class))
    (check-true (node-attr? el1 'class))
    (check-false (node-attr? el1 'id))))

;; 元素文本
(define/contract node-text
  (-> sxml:element? string?)
  (compose string-trim sxml:text))

(module+ test
  (test-case "node-text"
    (check-equal? "main text" (node-text el))
    (check-equal? "primary button" (node-text el1))
    (check-equal? "" (node-text el2))))

;; 无素标签名
(define/contract node-tag-name
  (-> sxml:element? string?)
  (compose string-trim sxml:ncname))

(module+ test
  (test-case "node-tag-name")
  (check-equal? "main" (node-tag-name el))
  (check-equal? "div" (node-tag-name el1))
  (check-equal? "input" (node-tag-name el2)))

;; 元素的id
(define/contract (node-id el)
  (-> sxml:element? (or/c #f string?))
  (node-attr el 'id))

(module+ test
  (test-case "node-id"
    (check-equal? "main-id" (node-id el))
    (check-false (node-id el1))
    (check-false (node-id el2))))

;; 是否有对应id
(define/contract (node-id? el id)
  (-> sxml:element? string? boolean?)
  (let ([the-id (node-id el)])
    (equal? the-id id)))

(module+ test
  (test-case "node-id"
    (check-true (node-id? el "main-id"))
    (check-false (node-id? el "mainid"))
    (check-false (node-id? el1 "main-id"))
    (check-false (node-id? el2 "main-id"))))

;; 元素样式类
(define/contract (node-class el)
  (-> sxml:element? (listof string?))
  (let ([the-class (node-attr el 'class)])
    (if the-class (string-split the-class) empty)))

(module+ test
  (test-case "node-class"
    (check-empty? (node-class el))
    (check-equal? '("button") (node-class el1))
    (check-equal? '("input") (node-class el2))))

;; 是否包含该样式类
(define/contract (node-class? el classname)
  (-> sxml:element? string? boolean?)
  (let* ([the-class (node-class el)]
         [the-mem (member classname the-class)])
    (and the-mem (not (null? the-mem)))))

(module+ test
  (test-case "node-class?"
    (check-false (node-class? el "main"))
    (check-false (node-class? el1 "div"))
    (check-true (node-class? el1 "button"))
    (check-true (node-class? el2 "input"))))
