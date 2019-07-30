#lang info
(define collection "zubat")
(define deps '("base"
               "html-parsing"
               "sxml"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("man/zubat.scrbl" ())))
(define pkg-desc "HTML 5文件解析")
(define version "0.0.4")
(define pkg-authors '(XG.Ley))
