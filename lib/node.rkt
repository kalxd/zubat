#lang racket/base

(provide file->sxml
         html->xexp

         html/attr)

(require racket/file
         racket/function
         racket/contract
         racket/list
         html-parsing
         sxml

         "type.rkt")

;;; 测试基本数据
(module+ test
  (require rackunit)

  (define el '(main (@ (id "main-id")
                       (class "container"))
                    "main text"
                    (nav (a (@ (href "link1")) "item 1")
                         (a (@ (href "link2")) "item 2"))))
  )

(define file->sxml
  (compose html->xexp
           (λ (path) (file->string path #:mode 'text))))

(module+ test
  (define el1 '(div (@ (class "button")) "button"))
  (define el2 '(input (@ (class "input") (type "text"))))

  (test-case "html/attr"
    (check-equal? "main-id" (html/attr 'id el))
    (check-equal? "button" (html/attr 'class el1))
    (check-equal? "text" (html/attr 'type el2)))
  )

(define/contract (html/attr attr el)
  (-> symbol? sxml:element? (maybe/c string?))
  (define attr-list (sxml:attr-list el))
  (ormap (λ (p) (let ([k (first p)]
                      [v (last p)])
                  (and (equal? attr k) v)))
         attr-list))
