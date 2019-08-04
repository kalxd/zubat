#lang racket/base

(require racket/contract
         sxml
         "node.rkt")

(provide (all-defined-out))

(module+ test
  (require "test-kit.rkt")

  (define-simple-check (check-tag? name el)
    (equal? name (node-tag-name el)))

  (define el '(main (@ (id "main"))
                    "hehe"
                    (nav (@ (class "nav bar"))
                         (a (@ (class "item") (href "href1")) "item 1")
                         (a (@ (class "item") (href "href2")) "item 2")
                         (a (@ (class "item") (href "href3")) "item 3"))
                    (div (@ (class "main body") (id "body"))
                         (p "text")))))

;; 子元素列表
(define/contract node-children
  (-> sxml:element? nodeset?)
  (sxml:child sxml:element?))

(module+ test
  (test-case "node-children"
    (check-equal? 2 (length (node-children el)))
    (let ([el1 '(div (p) (p) (p))]
          [el2 '(div)])
      (check-length? 3 (node-children el1))
      (check-length? 0 (node-children el2)))))
