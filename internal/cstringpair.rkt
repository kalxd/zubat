#lang azelf

(require "./type.rkt")

(require/typed "./ffi/cstringpair.rkt"
  [cstring-pair-first (-> CType CType)]
  [cstring-pair-second (-> CType CType)])

(require/typed "./ffi/primitive.rkt"
  [cstring->string (-> CType String)])

(provide (rename-out [out/cstring-pair-first cstring-pair-first]
                     [out/cstring-pair-second cstring-pair-second]))

(: out/cstring-pair-first (-> CType String))
(define (out/cstring-pair-first ptr)
  (->> ptr
       cstring-pair-first
       cstring->string))

(: out/cstring-pair-second (-> CType String))
(define (out/cstring-pair-second ptr)
  (->> ptr
       cstring-pair-second
       cstring->string))
