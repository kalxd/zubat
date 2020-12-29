#lang racket/base

(require racket/contract
         racket/list
         sxml
         "node.rkt"
         (only-in "./util.rkt" define/curry))

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
(define/curry node-children
  (-> (or/c empty? sxml:element?) nodeset?)
  (sxml:child sxml:element?))

(module+ test
  (test-case "node-children"
    (check-equal? 2 (length (node-children el)))
    (let ([el1 '(div (p) (p) (p))]
          [el2 '(div)])
      (check-length? 3 (node-children el1))
      (check-length? 0 (node-children el2)))))

;; 是否有子元素
(define/curry node-children?
  (-> (or/c empty? sxml:element?) boolean?)
  (compose not
           empty?
           node-children))

(module+ test
  (test-case "node-childre?"
    (check-true (node-children? el))
    (let ([el1 '(main)]
          [el2 '(a (@ (href "link")))])
      (check-false (node-children? el1))
      (check-false (node-children? el2)))))

(define/curry (node-child el)
  (-> (or/c empty? sxml:element?) (or/c #f sxml:element?))
  (let ([the-children (node-children el)])
    (if (empty? the-children)
        #f
        (first the-children))))

(module+ test
  (test-case "node-child"
    (check-equal? '("nav" "bar") (node-class (node-child el)))
    (let ([empty-el '()]
          [el1 '(div (p))])
      (check-false (node-child empty-el))
      (check-equal? "p" (node-tag-name (node-child el1))))))

;; 深度遍历所有节点
(define/curry (node-all-children el)
  (-> (or/c empty? sxml:element?) nodeset?)
  (foldl (λ (el xs)
           (let ([the-children (node-all-children el)])
             (append xs (cons el the-children))))
         empty
         (node-children el)))

(module+ test
  (test-case "node-all-children"
    (check-length? 6 (node-all-children el))
    (let ([el1 '(div (p) (p))]
          [el2 '(div)]
          [el3 '(div (div (div) (div)) (div))])
      (check-length? 2 (node-all-children el1))
      (check-length? 0 (node-all-children el2))
      (check-length? 4 (node-all-children el3)))))

;; 过滤所有元素
(define/curry (node-select el f)
  (-> (or/c empty? sxml:element?)
      (-> sxml:element? boolean?)
      nodeset?)
  (filter f (node-all-children el)))

(module+ test
  (define (select-class2 el)
    (= 2 (length (node-class el))))
    (test-case "node-select"
      (check-length? 2 (node-select el select-class2))
      (check-length? 3 (node-select el
                                    (λ (el)
                                      (node-class? el "item"))))
      (check-length? 1 (node-select el
                                    (λ (el)
                                      (equal? "p" (node-tag-name el)))))))

;; 只过滤出第一个元素
(define/curry (node-select-first el f)
  (-> (or/c empty? sxml:element?)
      (-> sxml:element? boolean?)
      (or/c #f sxml:element?))
  (let ([the-el (node-select el f)])
    (and (not (empty? the-el)) (first the-el))))

(module+ test
  (test-case "node-select-first"
    (let ([nav-el (node-select-first el (λ (el) (equal? "a" (node-tag-name el))))])
      (check-equal? "nav" (node-tag-name (node-select-first el select-class2)))
      (check-equal? "href1" (node-attr nav-el 'href))
      (check-equal? "item 1" (node-text nav-el)))))

;; 根据id查找元素
(define/curry (node-select-by-id el id)
  (-> (or/c empty? sxml:element?) string? (or/c #f sxml:element?))
  (let ([f (λ (n)
             (equal? id (node-attr n 'id)))])
    (node-select-first el f)))

(module+ test
  (test-case "node-select-id"
    (let ([body-el (node-select-by-id el "body")]
          [nil-el (node-select-by-id el "you-do-not-know-me")])
      (check-tag? "div" body-el)
      (check-false nil-el))))

;; 根据class查找元素
(define/curry (node-select-by-class el klass)
  (-> (or/c empty? sxml:element?) string? nodeset?)
  (define (f el)
    (node-class? el klass))
  (filter f (node-all-children el)))

(module+ test
  (test-case "node-select-by-class"
    (check-empty? (node-select-by-class el "unkown"))
    (check-length? 3 (node-select-by-class el "item"))))

(define/curry (node-select-first-by-class el klass)
  (-> sxml:element? string? (or/c #f sxml:element?))
  (let ([children (node-select-by-class el klass)])
    (if (empty? children)
        #f
        (car children))))

(module+ test
  (require net/url-string)

  (test-case "node-select-first-by-class"
    (check-false (node-select-first-by-class el "unkown"))
    (check-equal? "href1"
                  (url->string
                   (node-href (node-select-first-by-class el "item"))))))
