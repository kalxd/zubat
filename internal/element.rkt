#lang azelf

(require/typed ffi/unsafe
  [#:opaque CType ctype?])
(require/typed "./ffi/element.rkt"
  [element-id (-> CType (Option CType))]
  [element-has-class (-> CType String Boolean)]
  [element-attr (-> CType String (Option CType))]
  [element-html (-> CType CType)]
  [element-inner-html (-> CType CType)])
(require/typed "./ffi/primitive.rkt"
  [cstring->string (-> CType String)])


(provide (rename-out [out/element-id element-id]
                     [out/element-class? element-class?]
                     [out/element-attr element-attr]
                     [out/element-html element-html]
                     [out/element-inner-html element-inner-html])
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

#|
(define/contract (try/element-attrs-next ptr)
  (-> cpointer? (Maybe/c cpointer?))
  (->> (ffi:element-attrs-next ptr)
       ->maybe))

(define/curry/contract (fold/element-attrs acc ptr)
  (-> (Map/c string? string?) cpointer? (Map/c string? string?))
  (match (try/element-attrs-next ptr)
    [(Just pair)
     (->> (map-insert (cstring-pair-first pair)
                      (cstring-pair-second pair)
                      acc)
          (fold/element-attrs it ptr))]
    [_ acc]))

(define/contract (element-attrs el)
  (-> Element? (Map/c string? string?))
  (define attrs-ptr
    (->> (Element-ptr el)
         ffi:element-attrs))
  (fold/element-attrs map-empty attrs-ptr))

(define/contract try/element-classes-next
  (-> cpointer? (Maybe/c string?))
  (>-> ffi:element-classes-next
       ->maybe
       (map cstring->string)))

(define/curry/contract (fold/element-classes xs ptr)
  (-> (Array/c string?) cpointer? (Array/c string?))
  (match (try/element-classes-next ptr)
    [(Just s)
     (->> (<:> s xs)
          (fold/element-classes it ptr))]
    [_ xs]))

(define/contract element-class
  (-> Element? (Array/c string?))
  (>-> Element-ptr
       ffi:element-classes
       (fold/element-classes empty)))

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
