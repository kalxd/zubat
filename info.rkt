#lang info
(define collection "zubat")
(define deps '("base"
               "html-parsing"
               "sxml"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/zubat.scrbl" ())))
(define pkg-desc "HTML 5简易解释器。")
(define version "0.2.0")
(define pkg-authors '(XG.Ley))
