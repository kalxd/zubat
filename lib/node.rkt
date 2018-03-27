#lang racket/base

(provide file->sxml
         html->xexp

         html/attr)

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

  (define el '(main (@ (id "main-id")
                       (class "container"))
                    "main text"
                    (nav (a (@ (href "link1")) "item 1")
                         (a (@ (href "link2")) "item 2"))))

  (define el1 '(div (@ (class "button")) "primary button"))
  (define el2 '(input (@ (class "input") (type "text"))))
  )

(define file->sxml
  (compose html->xexp
           (λ (path) (file->string path #:mode 'text))))

;; 元素属性
(define/contract (html/attr attr el)
  (-> symbol? sxml:element? (maybe/c string?))
  (sxml:attr el attr))

(module+ test
  (test-case "html/attr"
    (check-equal? "main-id" (html/attr 'id el))
    (check-equal? "button" (html/attr 'class el1))
    (check-equal? "text" (html/attr 'type el2)))
  )

;; 元素文本
(define/contract html/text
  (-> sxml:element? string?)
  sxml:text)

(module+ test
  (test-case "html/text"
    (check-equal? "main text" (html/text el))
    (check-equal? "primary button" (html/text el1))
    (check-true (not (non-empty-string? (html/text el2)))))
  )

;; 元素名称
(define/contract html/tag-name
  (-> sxml:element? string?)
  sxml:ncname)

(module+ test
  (test-case "html/tag-name"
    (check-equal? "main" (html/tag-name el))
    (check-equal? "div" (html/tag-name el1))
    (check-equal? "input" (html/tag-name el2)))
  )
