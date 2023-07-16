#lang azelf

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc
         ffi/unsafe/define/conventions
         (for-syntax racket/base
                     racket/syntax))

(provide (all-defined-out)
         (all-from-out ffi/unsafe/define)
         (all-from-out ffi/unsafe)
         (all-from-out ffi/unsafe/alloc))

(define-syntax (define-ptr stx)
  (syntax-case stx ()
    [(_ name)
     (with-syntax ([name (format-id stx "_~a-ptr*" #'name)]
                   [ptr (format-id stx "_~a_ptr" #'name)])
         #'(define ptr (_cpointer 'name)))]))

(define-ffi-definer define-golbat
  (ffi-lib "libgolbatd.so")
  #:make-c-id convention:hyphen->underscore)
