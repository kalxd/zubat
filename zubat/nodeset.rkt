#lang azelf

(require (only-in racket/list
                  empty?)
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
                     (node-search-by (node-class? "item")
                                     el))
      (check-length? 1
                     (node-search-by (ntype?? 'p)
                                     el))))


;; 只过滤出第一个元素
(define/curry/contract (node-search-first-by f el)
  (-> (-> sxml:element? boolean?)
      sxml:element?
      (Maybe/c sxml:element?))
  (->maybe
   (for/or ([x (node-children el)])
     (or (->> (node-search-first-by f x)
              (maybe-> #f))
         (and (f x) x)))))

(module+ test
  (test-case "node-select-first"
    (define nav-el
      (node-search-first-by (ntype?? 'a) el))

    (check-equal? (Just "nav")
                  (->> (node-search-first-by select-class2 el)
                       (maybe-map node-tag)))
    (check-equal? (Just "href1")
                  (->> nav-el
                       (maybe-then (node-attr 'href))))
    (check-equal? (Just "item 1")
                  (->> nav-el
                       (maybe-map node-text)))))

; 根据id查找元素
(define/curry/contract (node-by-id id el)
  (-> string? sxml:element? (Maybe/c sxml:element?))
  (node-search-first-by (node-id? id) el))

(module+ test
  (test-case "node-select-id"
    (check-equal? (Just "div")
                  (->> (node-by-id "body" el)
                       (maybe-map node-tag)))
    (check-equal? nothing
                  (maybe/do
                   (x <- (node-by-id "you-dont-know-me" el))
                   (node-tag x)))))

;; 根据class查找元素
(define/curry/contract (node-by-class klass el)
  (-> string? sxml:element? nodeset?)
  (->> (node-all-children el)
       (filter (node-class? klass) it)))

(module+ test
  (test-case "node-by-class"
    (check-pred empty? (node-by-class "unkown" el))
    (check-length? 3 (node-by-class "item" el))))

(define/curry/contract (node-first-by-class klass el)
  (-> string? sxml:element? (Maybe/c sxml:element?))
  (node-search-first-by (node-class? klass) el))

(module+ test
  (test-case "node-select-first-by-class"
    (check-equal? nothing
                  (node-first-by-class "unkown" el))
    (check-equal? (Just "href1")
                  (maybe/do
                   (x <- (node-first-by-class "item" el))
                   (node-href x)))))
