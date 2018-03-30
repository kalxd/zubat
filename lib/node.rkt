#lang racket/base

(provide file->sxml
         html->xexp

         zubat:attr
         zubat:text
         zubat:tag)

(require racket/file
         racket/contract
         racket/list
         html-parsing
         sxml

         "type.rkt")

;;; 测试基本数据
(module+ test
  (require rackunit
           racket/string)

  (define el '(main (@ (id "main-id")) "main text"))
  (define el1 '(div (@ (class "button")) "primary button"))
  (define el2 '(input (@ (class "input") (type "text")))))

(define file->sxml
  (compose html->xexp
           (λ (path) (file->string path #:mode 'text))))

;; 元素属性
(define/contract (zubat:attr attr el)
  (-> symbol? sxml:element? (maybe/c string?))
  (sxml:attr el attr))

(module+ test
  (test-case "zubat:attr"
    (check-equal? "main-id" (zubat:attr 'id el))
    (check-equal? "button" (zubat:attr 'class el1))
    (check-equal? "text" (zubat:attr 'type el2))))

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
