#lang azelf

(require/typed ffi/unsafe [#:opaque CPointer cpointer?])
(require/typed "./ffi/cstringpair.rkt"
  [cstring-pair-first (-> CPointer CPointer)]
  [cstring-pair-second (-> CPointer CPointer)])
(require/typed "./ffi/primitive.rkt" [cstring->string (-> CPointer String)])

(require "./ffi/primitive.rkt"
         (prefix-in ffi:: "./ffi/cstringpair.rkt"))

(provide (rename-out [out/cstring-pair-first cstring-pair-first]
                     [out/cstring-pair-second cstring-pair-second]))

(: out/cstring-pair-first (-> CPointer String))
(define (out/cstring-pair-first ptr)
  (->> ptr
       cstring-pair-first
       cstring->string))

(: out/cstring-pair-second (-> CPointer String))
(define (out/cstring-pair-second ptr)
  (->> ptr
       cstring-pair-second
       cstring->string))
