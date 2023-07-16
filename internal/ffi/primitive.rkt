#lang azelf

(require "./util.rkt")

(define-ptr cstring)

(define-golbat free-cstring
  (_fun _cstring_ptr -> _void)
  #:wrap (deallocator))
