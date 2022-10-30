#lang info
(define collection "zubat")
(define deps '("azelf"
               "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"))
(define scribblings '(("scribblings/zubat.scrbl" ())))
(define pkg-desc "走rust ffi的html5解释器")
(define version "0.5.0")
(define pkg-authors '(XG.Ley))
