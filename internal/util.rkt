#lang azelf

(require (prefix-in ffi: "./ffi.rkt")
         (only-in racket/list
                  empty))

(provide (all-defined-out))

(struct Html [ptr])
(struct Html-Iter [ptr])

(struct Element [ptr])
(struct Element-Iter [ptr])

(define/match1/contract try-next-select
  (-> (or/c Html-Iter? Element-Iter?) (Maybe/c Element?))
  [(Html-Iter ptr)
   (maybe/do
    (n <- (ffi:next-html-select ptr))
    (Element n))]
  [(Element-Iter ptr)
   (maybe/do
    (n <- (ffi:next-element-select ptr))
    (Element n))])

(define/curry/contract (*html-iter->element-list xs iter)
  (-> (listof Element?) Html-Iter? (listof Element?))
  (match (try-next-select iter)
    [(Just el)
     (->> (list el)
          (concat xs it)
          (*html-iter->element-list it iter))]
    [_ xs]))

(define/contract html-iter->element-list
  (-> Html-Iter? (listof Element?))
  (*html-iter->element-list empty))

(define/curry/contract (*element-iter->element-list xs iter)
  (-> (listof Element?) Element-Iter? (listof Element?))
  (match (try-next-select iter)
    [(Just el)
     (->> (list el)
          (concat xs it)
          (*element-iter->element-list it iter))]
    [_ xs]))

(define/contract element-iter->element-list
  (-> Element-Iter? (listof Element?))
  (*element-iter->element-list empty))
