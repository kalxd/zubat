#lang racket/base

(require "./util.rkt")

(provide (all-defined-out))

(define-ptr cstring)

(define-golbat free-cstring
  (_fun _cstring_ptr -> _void)
  #:wrap (deallocator))

(define (cstring->string ptr)
  (define s
    (cast ptr _cstring_ptr _string))
  (free-cstring ptr)
  s)
