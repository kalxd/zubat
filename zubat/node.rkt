#lang racket/base

(module+ test
  (require "test-kit.rkt")
  (displayln "测试开始！")
  (define el '(main (@ (id "main-id")) "main text"))
  (define el1 '(div (@ (class "button")) "primary button"))
  (define el2 '(input (@ (class "input") (type "text")))))
