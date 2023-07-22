#lang azelf

(require (prefix-in ffi: "./ffi/element.rkt")
         (prefix-in ffi: "./ffi/select.rkt")
         "./ffi/primitive.rkt"
         "./cstringpair.rkt"
         (only-in ffi/unsafe cpointer?))

(provide (all-defined-out))

(struct Element [ptr])

(define/contract (element-id el)
  (-> Element? (Maybe/c string?))
  (->> (Element-ptr el)
       ffi:element-id
       ->maybe
       (map cstring->string)))

(define/curry/contract (element-class? klass el)
  (-> string? Element? boolean?)
  (->> (Element-ptr el)
       (ffi:element-has-class it klass)))

(define/curry/contract (element-attr name el)
  (-> string? Element? (Maybe/c string?))
  (->> (Element-ptr el)
       (ffi:element-attr it name)
       ->maybe
       (map cstring->string)))

(define/contract element-href
  (-> Element? (Maybe/c string?))
  (element-attr "href"))

(define/contract element-value
  (-> Element? (Maybe/c string?))
  (element-attr "value"))

(define/contract element-html
  (-> Element? string?)
  (>-> Element-ptr
       ffi:element-html
       cstring->string))

(define/contract element-inner-html
  (-> Element? string?)
  (>-> Element-ptr
       ffi:element-inner-html
       cstring->string))

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

(define/contract (try/element-select-next ptr)
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
