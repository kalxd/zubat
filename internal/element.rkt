#lang azelf

(require typed/racket/unsafe)

(unsafe-require/typed "./ffi/element.rkt"
  [element-id (-> Any (Option Any))]
  [element-has-class (-> Any String Boolean)]
  [element-attr (-> Any String (Option Any))]
  [element-html (-> Any Any)]
  [element-inner-html (-> Any Any)]
  [element-attrs-next (-> Any (Option Any))]
  [element-attrs (-> Any Any)]
  [element-classes (-> Any Any)]
  [element-classes-next (-> Any (Option Any))]
  [element-select (-> Any Any Any)]
  [element-select-next (-> Any (Option Any))]
  [element-text (-> Any (Option Any))])

(unsafe-require/typed "./ffi/selector.rkt"
  [build-selector (-> String Any)])

(unsafe-require/typed "./ffi/primitive.rkt"
  [cstring->string (-> Any String)])

(require "./cstringpair.rkt")

(provide Element
         Element?
         (rename-out [out/element-id element-id]
                     [out/element-class? element-class?]
                     [out/element-attr element-attr]
                     [out/element-html element-html]
                     [out/element-inner-html element-inner-html]
                     [out/element-attrs element-attrs]
                     [out/element-classes element-classes]
                     [out/element-query element-query]
                     [out/element-query1 element-query1]
                     [out/element-text element-text])
         element-href
         element-value)

(struct Element ([ptr : Any]))

(: out/element-id (-> Element (Option String)))
(define (out/element-id el)
  (->> (Element-ptr el)
       element-id
       (option/map it cstring->string)))

(: out/element-class? (-> Element String Boolean))
(define (out/element-class? el klass)
  (->> (Element-ptr el)
       (element-has-class it klass)))

(: out/element-attr (-> Element String (Option String)))
(define (out/element-attr el name)
  (->> (Element-ptr el)
       (element-attr it name)
       (option/map it cstring->string)))

(: element-href (-> Element (Option String)))
(define (element-href el)
  (out/element-attr el "href"))

(: element-value (-> Element (Option String)))
(define (element-value el)
  (out/element-attr el "value"))

(: out/element-html (-> Element String))
(define (out/element-html el)
  (->> (Element-ptr el)
       element-html
       cstring->string))

(: out/element-inner-html (-> Element String))
(define (out/element-inner-html el)
  (->> (Element-ptr el)
       element-inner-html
       cstring->string))

(: fold/element-attrs
   (-> Any
       (Immutable-HashTable String String)
       (Immutable-HashTable String String)))
(define (fold/element-attrs ptr acc)
  (define attr-ptr (element-attrs-next ptr))
  (cond
    [(eq? #f attr-ptr) acc]
    [else (let ([key (cstring-pair-first attr-ptr)]
                [value (cstring-pair-second attr-ptr)])
            (hash-set acc key value))]))

(: out/element-attrs (-> Element (Immutable-HashTable String String)))
(define (out/element-attrs el)
  (define attrs-ptr (->> (Element-ptr el)
                         element-attrs))
  (fold/element-attrs attrs-ptr (hash)))

(: fold/element-classes
   (-> Any
       (Listof String)
       (Listof String)))
(define (fold/element-classes ptr acc)
  (define klass (->> (element-classes-next ptr)
                     (option/map it cstring->string)))
  (cond
    [(eq? #f klass) acc]
    [else (let ([acc- (cons klass acc)])
            (fold/element-classes ptr acc-))]))

(: out/element-classes (-> Element (Listof String)))
(define (out/element-classes el)
  (->> (Element-ptr el)
       element-classes
       (fold/element-classes it (list))))

(: fold/element-select (-> Any (Listof Element) (Listof Element)))
(define (fold/element-select select-ptr acc)
  (define el-ptr (element-select-next select-ptr))
  (cond
    [(none? el-ptr) acc]
    [else (->> (Element el-ptr)
               (append acc (list it))
               (fold/element-select select-ptr it))]))

(: out/element-query (-> Element String (Listof Element)))
(define (out/element-query el selector)
  (define selector-ptr (build-selector selector))
  (define select-ptr
    (->> (Element-ptr el)
         (element-select it selector-ptr)))
  (fold/element-select select-ptr (list)))


(: out/element-query1 (-> Element String (Option Element)))
(define (out/element-query1 el selector)
  (define selector-ptr (build-selector selector))
  (define el-ptr
    (->> (Element-ptr el)
         (element-select it selector-ptr)
         element-select-next))
  (option/map el-ptr Element))

(: out/element-text (-> Element (Option String)))
(define (out/element-text el)
  (->> (Element-ptr el)
       element-text
       (option/map it cstring->string)))
