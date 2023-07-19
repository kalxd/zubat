#lang azelf

(require (prefix-in ffi: "./ffi/element.rkt")
         "./ffi/primitive.rkt")

(provide (all-defined-out))

(struct Element [ptr])

(define/contract (element-id el)
  (-> Element? (Maybe/c string?))
  (->> (Element-ptr el)
       ffi:element-id
       ->maybe
       (map cstring->string)))

(define/contract (element-class? klass el)
  (-> string? Element? boolean?)
  (->> (Element-ptr el)
       (ffi:element-has-class it klass)))

(define/contract (element-attr name el)
  (-> string? Element? (Maybe/c string?))
  (->> (Element-ptr el)
       (ffi:element-attr it name)
       ->maybe
       (map cstring->string)))
