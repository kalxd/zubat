#lang azelf

(require "./util.rkt"
         "./primitive.rkt")

(provide (all-defined-out))

(define-ptr cstring_pair)

(define-golbat free-cstring-pair
  (_fun _cstring_pair_ptr -> _void)
  #:wrap (deallocator))

(define-golbat cstring-pair-first
  (_fun _cstring_pair_ptr -> _cstring_ptr)
  #:wrap (deallocator))

(define-golbat cstring-pair-second
  (_fun _cstring_pair_ptr -> _cstring_ptr)
  #:wrap (deallocator))
