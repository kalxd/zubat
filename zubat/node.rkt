#lang azelf

(require racket/contract
         racket/string
         racket/list
         sxml)

(provide (all-defined-out))

(module+ test
  (require rackunit)
  (define el '(main (@ (id "main-id")) "main text"))
  (define el1 '(div (@ (class "button")) "primary button"))
  (define el2 '(input (@ (class "input") (type "text") (value "input"))))
  (define el4 '(a (@ (href "link.html") (type "text")))))

;; 元素属性
(define/curry/contract (node-attr attr el)
  (-> symbol? sxml:element? (Maybe/c string?))
  (maybe/do
   (attr <- (sxml:attr el attr))
   (string-trim attr)))

(module+ test
  (test-case "node-attr"
    (define get-class (node-attr 'class))
    (define get-id (node-attr 'id))

    (check-equal? (Just "main-id") (get-id el))
    (check-equal? (Just "button") (get-class el1))
    (check-equal? nothing (get-class el))
    (check-equal? (Just "text") (node-attr 'type el2))
    (check-equal? nothing (get-id el2))))

;; 是否有这个属性。
(define/curry/contract (node-attr? attr el)
  (-> symbol? sxml:element? boolean?)
  (match (node-attr attr el)
    [(Just _) #t]
    [_ #f]))

(module+ test
  (test-case "node-attr?"
    (check-true (node-attr? 'id el))
    (check-false (node-attr? 'class el))
    (check-true (node-attr? 'class el1))
    (check-false (node-attr? 'id el1))))

;; 元素文本
(define/contract node-text
  (-> sxml:element? string?)
  (compose string-trim sxml:text))

(module+ test
  (test-case "node-text"
    (check-equal? "main text" (node-text el))
    (check-equal? "primary button" (node-text el1))
    (check-equal? "" (node-text el2))))

;; 无素标签名
(define/contract node-tag
  (-> sxml:element? string?)
  (compose string-trim sxml:ncname))

(module+ test
  (test-case "node-tag")
  (check-equal? "main" (node-tag el))
  (check-equal? "div" (node-tag el1))
  (check-equal? "input" (node-tag el2)))

;; 元素的id
(define/contract node-id
  (-> sxml:element? (Maybe/c string?))
  (node-attr 'id))

(module+ test
  (test-case "node-id"
    (check-equal? (Just "main-id") (node-id el))
    (check-equal? nothing (node-id el1))
    (check-equal? nothing (node-id el2))))

;; 是否有对应id
(define/curry (node-id? id el)
  (-> string? sxml:element? boolean?)
  (->> (node-id el)
       (maybe-map (λ (id-) (equal? id id-)))
       (maybe-> #f)))

(module+ test
  (test-case "node-id"
    (check-true (node-id? "main-id" el))
    (check-false (node-id? "mainid" el))
    (check-false (node-id? "main-id" el1))
    (check-false (node-id? "main-id" el2))))

;; 元素样式类
(define/contract (node-class el)
  (-> sxml:element? (listof string?))
  (match (node-attr 'class el)
    [(Just klass) (string-split klass)]
    [_ empty]))

(module+ test
  (test-case "node-class"
    (check-equal? empty (node-class el))
    (check-equal? '("button") (node-class el1))
    (check-equal? '("input") (node-class el2))))

;; 是否包含该样式类
(define/curry (node-has-class? classname el)
  (-> string? sxml:element? boolean?)
  (let* ([the-class (node-class el)]
         [the-mem (member classname the-class)])
    (and the-mem (not (null? the-mem)))))

(module+ test
  (test-case "node-class?"
    (check-false (node-has-class? "main" el))
    (check-false (node-has-class? "div" el1))
    (check-true (node-has-class? "button" el1))
    (check-true (node-has-class? "input" el2))))

;; 找出链接
(define/contract node-href
  (-> sxml:element? (Maybe/c string?))
  (node-attr 'href))

(module+ test
  (test-case "node-href"
    (check-equal? nothing (node-href el))
    (check-equal? (Just "link.html") (node-href el4))))

;; 找出value。
(define/contract node-value
  (-> sxml:element? (Maybe/c string?))
  (node-attr 'value))

(module+ test
  (test-case "node-value"
    (check-equal? (Just "input") (node-value el2))
    (check-equal? nothing (node-value el))))
