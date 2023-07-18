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
