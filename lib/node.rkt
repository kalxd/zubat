#lang racket/base

(provide (all-defined-out))

(require racket/file
         racket/contract
         racket/list
         racket/string
         html-parsing
         sxml

         "type.rkt")

;;; 测试基本数据
(module+ test
  (require "test-kit.rkt"
           racket/string)

  (define el '(main (@ (id "main-id")) "main text"))
  (define el1 '(div (@ (class "button")) "primary button"))
  (define el2 '(input (@ (class "input") (type "text")))))

;; 元素属性
(define/contract (zubat:attr attr el)
  (-> symbol? sxml:element? (maybe/c string?))
  (sxml:attr el attr))

(module+ test
  (test-case "zubat:attr"
    (check-equal? "main-id" (zubat:attr 'id el))
    (check-equal? "button" (zubat:attr 'class el1))
    (check-equal? "text" (zubat:attr 'type el2))))

;; 元素属性是否存在
(define/contract (zubat:attr? attr value el)
  (-> symbol? string? sxml:element? boolean?)
  (define el-attr (zubat:attr attr el))
  (equal? value el-attr))

(module+ test
  (test-case "zubat:attr?"
    (check-true (zubat:attr? 'id "main-id" el))
    (check-false (zubat:attr? 'id "id" el))
    (check-true (zubat:attr? 'class "button" el1))
    (check-true (zubat:attr? 'class "input" el2))
    (check-false (zubat:attr? 'value "input" el2))))

;; 元素文本
(define/contract zubat:text
  (-> sxml:element? string?)
  sxml:text)

(module+ test
  (test-case "zubat:text"
    (check-equal? "main text" (zubat:text el))
    (check-equal? "primary button" (zubat:text el1))
    (check-true (not (non-empty-string? (zubat:text el2))))))

;; 元素名称
(define/contract zubat:tag
  (-> sxml:element? string?)
  sxml:ncname)

(module+ test
  (test-case "zubat:tag"
    (check-equal? "main" (zubat:tag el))
    (check-equal? "div" (zubat:tag el1))
    (check-equal? "input" (zubat:tag el2))))

;; 元素id
(define/contract (zubat:id el)
  (-> sxml:element? (maybe/c string?))
  (zubat:attr 'id el))

(module+ test
  (test-case "zubat:id"
    (check-equal? "main-id" (zubat:id el))
    (check-equal? #f (zubat:id el1))
    (check-equal? #f (zubat:id el2))))

;; 元素class
(define/contract zubat:class
  (-> sxml:element? (listof string?))
  (compose (λ (s) (if s (string-split s) empty))
           (λ (el) (zubat:attr 'class el))))

(module+ test
  (test-case "zubat:class"
    (check-empty? (zubat:class el))
    (check-equal? '("button") (zubat:class el1))
    (check-equal? '("input") (zubat:class el2))))

;; 元素是否有class
(define/contract (zubat:class? name el)
  (-> string? sxml:element? boolean?)
  (define class-list (zubat:class el))
  (and (index-of class-list name) #t))

(module+ test
  (test-case "zubat:class?"
    (check-false (zubat:class? "main" el))
    (check-false (zubat:class? "div" el1))
    (check-true (zubat:class? "button" el1))
    (check-true (zubat:class? "input" el2))))
