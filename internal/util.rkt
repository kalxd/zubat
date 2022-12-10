#lang azelf

(require (prefix-in ffi: "./ffi.rkt"))

(provide (all-defined-out))

(struct Html [ptr])
(struct Html-Iter [ptr])

(struct Element [ptr])
(struct Element-Iter [ptr])
(struct Element-Text-Iter [ptr])
(struct Element-Class-Iter [ptr])

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

(define/match1/contract try-next-string
  (-> (or/c Element-Text-Iter? Element-Class-Iter?) (Maybe/c string?))
  [(Element-Text-Iter ptr)
   (->> (ffi:next-element-text ptr)
        ->maybe)]
  [(Element-Class-Iter ptr)
   (->> (ffi:next-element-classes ptr)
        ->maybe)])

(define/curry/contract (*html-iter->element-list xs iter)
  (-> (Array/c Element?) Html-Iter? (Array/c Element?))
  (match (try-next-select iter)
    [(Just el)
     (->> (<:> el xs)
          (*html-iter->element-list it iter))]
    [_ xs]))

(define/contract html-iter->element-list
  (-> Html-Iter? (Array/c Element?))
  (*html-iter->element-list empty))

(define/curry/contract (*element-iter->element-list xs iter)
  (-> (Array/c Element?) Element-Iter? (Array/c Element?))
  (match (try-next-select iter)
    [(Just el)
     (->> (<:> el xs)
          (*element-iter->element-list it iter))]
    [_ xs]))

(define/contract element-iter->element-list
  (-> Element-Iter? (Array/c Element?))
  (*element-iter->element-list empty))

(define/curry/contract (*element-text-iter->string-list xs iter)
  (-> (Array/c string?) Element-Text-Iter? (Array/c string?))
  (match (try-next-string iter)
    [(Just t)
     (->> (<:> t xs)
          (*element-text-iter->string-list it iter))]
    [_ xs]))

(define/contract element-text-iter->string-list
  (-> Element-Text-Iter? (Array/c string?))
  (*element-text-iter->string-list empty))

(define/curry/contract (*element-class-iter->string-list xs iter)
  (-> (Array/c string?) Element-Class-Iter? (Array/c string?))
  (match (try-next-string iter)
    [(Just s)
     (->> (<:> s xs)
          (*element-class-iter->string-list it iter))]
    [_ xs]))

(define/contract element-class-iter->string-list
  (-> Element-Class-Iter? (Array/c string?))
  (*element-class-iter->string-list empty))
