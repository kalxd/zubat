#lang racket/base

(require racket/contract
         racket/string
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
