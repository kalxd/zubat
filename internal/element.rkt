#lang azelf

(require "./type.rkt")

(require/typed "./ffi/element.rkt"
  [element-id (-> CType (Option CType))]
  [element-has-class (-> CType String Boolean)]
  [element-attr (-> CType String (Option CType))]
  [element-html (-> CType CType)]
  [element-inner-html (-> CType CType)]
  [element-attrs-next (-> CType (Option CType))]
  [element-attrs (-> CType CType)]
  [element-classes (-> CType CType)]
  [element-classes-next (-> CType (Option CType))])

(require/typed "./ffi/primitive.rkt"
  [cstring->string (-> CType String)])

(require "./cstringpair.rkt")

(provide (rename-out [out/element-id element-id]
                     [out/element-class? element-class?]
                     [out/element-attr element-attr]
                     [out/element-html element-html]
                     [out/element-inner-html element-inner-html]
                     [out/element-attrs element-attrs]
                     [out/element-classes element-classes])
         element-href
         element-value)

(struct Element ([ptr : CType]))

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
   (-> CType
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
   (-> CType
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
#|
(define/contract try/element-select-next
  (-> cpointer? (Maybe/c Element?))
  (>-> ffi:element-select-next
       ->maybe
       (map Element)))

(define/curry/contract (fold/element-select xs ptr)
  (-> (Array/c Element?) cpointer? (Array/c Element?))
  (match (try/element-select-next ptr)
    [(Just x)
     (->> (<:> x xs)
          (fold/element-select it ptr))]
    [_ xs]))

(define/contract element-select->array
  (-> cpointer? (Array/c Element?))
  (fold/element-select empty))

(define/curry/contract (element-query selector el)
  (-> string? Element? (Array/c Element?))
  (define selector-ptr (ffi:build-selector selector))
  (match-define (Element el-ptr) el)
  (->> (ffi:element-select el-ptr selector-ptr)
       element-select->array))

(define/curry/contract (element-query1 selector el)
  (-> string? Element? (Maybe/c Element?))
  (define selector-ptr (ffi:build-selector selector))
  (match-define (Element el-ptr) el)
  (->> (ffi:element-select el-ptr selector-ptr)
       try/element-select-next))

(define/contract (element-text el)
  (-> Element? (Maybe/c string?))
  (->> (Element-ptr el)
       ffi:element-text
       ->maybe
       (map cstring->string)))
|#
