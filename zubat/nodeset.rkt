#lang azelf

(require racket/list
         (only-in racket/function
                  identity)
         sxml
         "node.rkt")

(provide (all-defined-out))

(module+ test
  (require rackunit)

  (define-simple-check (check-tag? name el)
    (equal? name (node-tag el)))

  (define-simple-check (check-length? n xs)
    (->> (length xs)
         (= n it)))

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
  sxml:child-elements)

(module+ test
  (test-case "node-children"
    (check-equal? 2 (length (node-children el)))
    (let ([el1 '(div (p) (p) (p))]
          [el2 '(div)])
      (check-length? 3 (node-children el1))
      (check-length? 0 (node-children el2)))))

;; 是否有子元素
(define/contract node-children?
  (-> sxml:element? boolean?)
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

; 第一个子元素
(define/contract (node-first-child el)
  (-> sxml:element? (Maybe/c sxml:element?))
  (->> el
       (select-first-kid sxml:element?)
       ->maybe))

(module+ test
  (test-case "node-first-child"
    (check-equal? (Just (list "nav" "bar"))
                  (->> (node-first-child el)
                       (maybe-map node-class)))
    (check-pred Nothing? (node-first-child '(div)))
    (check-equal? (Just "p")
                  (->> (node-first-child '(div (p) (a)))
                       (maybe-map node-tag)))))
;; 深度遍历所有节点
(define/contract node-all-children
  (-> sxml:element? nodeset?)
  (sxml:descendant sxml:element?))

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
(define/curry/contract (node-search-by f el)
  (-> (-> sxml:element? boolean?)
      sxml:element?
      nodeset?)
  (define (g node)
    (and (sxml:element? node)
         (let ([value (f node)])
           (and value node))))
  ((sxml:descendant g) el))

(module+ test
  (define (select-class2 el)
    (= 2 (length (node-class el))))
    (test-case "node-select"
      (check-length? 2
                     (node-search-by select-class2 el))
      (check-length? 3
                     (node-search-by (node-has-class? "item")
                                     el))
      (check-length? 1
                     (node-search-by (ntype?? 'p)
                                     el))))

#|
;; 只过滤出第一个元素
(define/curry/contract (node-search-first f el)
  (-> (-> sxml:element? boolean?)
      sxml:element?
      (or/c #f sxml:element?))
  (let ([the-el (node-select el f)])
    (and (not (empty? the-el)) (first the-el))))

(module+ test
  (test-case "node-select-first"
    (let ([nav-el (node-select-first el (λ (el) (equal? "a" (node-tag el))))])
      (check-equal? "nav" (node-tag (node-select-first el select-class2)))
      (check-equal? "href1" (node-attr nav-el 'href))
      (check-equal? "item 1" (node-text nav-el)))))

; 根据id查找元素
(define/curry (node-search-by-id el id)
  (-> (or/c empty? sxml:element?) string? (or/c #f sxml:element?))
  (let ([f (λ (n)
             (equal? id (node-attr n 'id)))])
    (node-select-first el f)))

(module+ test
  (test-case "node-select-id"
    (let ([body-el (node-search-by-id el "body")]
          [nil-el (node-search-by-id el "you-do-not-know-me")])
      (check-tag? "div" body-el)
      (check-false nil-el))))

;; 根据class查找元素
(define/curry (node-search-by-class el klass)
  (-> (or/c empty? sxml:element?) string? nodeset?)
  (define (f el)
    (node-class? el klass))
  (filter f (node-all-children el)))

(module+ test
  (test-case "node-search-by-class"
    (check-pred empty? (node-search-by-class el "unkown"))
    (check-length? 3 (node-search-by-class el "item"))))

(define/curry (node-select-first-by-class el klass)
  (-> sxml:element? string? (or/c #f sxml:element?))
  (let ([children (node-search-by-class el klass)])
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
|#
