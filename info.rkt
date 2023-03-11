#lang info
(define collection "zubat")
(define deps '("azelf #:version 0.4.0"
               "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"))
(define scribblings '(("scribblings/zubat.scrbl" ())))
(define pkg-desc "走rust ffi的html5解释器")
(define version "0.6")
(define pkg-authors '(XG.Ley))
