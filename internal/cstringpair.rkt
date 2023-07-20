#lang azelf

(require "./ffi/primitive.rkt"
         (prefix-in ffi: "./ffi/cstringpair.rkt")
         (only-in ffi/unsafe cpointer?))

(provide (all-defined-out))

(define/contract cstring-pair-first
  (-> cpointer? string?)
  (>-> ffi:cstring-pair-first
       cstring->string))

(define/contract cstring-pair-second
  (-> cpointer? string?)
  (>-> ffi:cstring-pair-second
       cstring->string))
