#lang info
(define collection "zubat")
(define deps '("base"
               "html-parsing"
               "sxml"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/zubat.scrbl" ())))
(define pkg-desc "HTML 5文件解析")
(define version "0.1.1")
(define pkg-authors '(XG.Ley))
