#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc
         ffi/unsafe/define/conventions
         setup/dirs
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
  (ffi-lib
   (let ([lib-dir (find-user-lib-dir)])
     (or (and lib-dir
              (string-append (path->string lib-dir)
                             "/"
                             "libgolbat"))
         "libgolbat.so")))
  #:make-c-id convention:hyphen->underscore)
