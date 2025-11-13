#lang azelf

(require/typed "./ffi/cstringpair.rkt"
  [cstring-pair-first (-> Any Any)]
  [cstring-pair-second (-> Any Any)])

(require/typed "./ffi/primitive.rkt"
  [cstring->string (-> Any String)])

(provide (rename-out [out/cstring-pair-first cstring-pair-first]
                     [out/cstring-pair-second cstring-pair-second]))

(: out/cstring-pair-first (-> Any String))
(define (out/cstring-pair-first ptr)
  (->> ptr
       cstring-pair-first
       cstring->string))

(: out/cstring-pair-second (-> Any String))
(define (out/cstring-pair-second ptr)
  (->> ptr
       cstring-pair-second
       cstring->string))
