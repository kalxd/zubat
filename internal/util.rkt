#lang azelf

(require (prefix-in ffi: "./ffi.rkt")
         (only-in racket/list
                  empty))

(provide (all-defined-out))

(struct Html [ptr])
(struct Element [ptr])
(struct Html-Iter [ptr])

(define/contract (try-next-html-select iter)
  (-> Html-Iter? (Maybe/c Element?))
  (match-define (Html-Iter iter-ptr) iter)
  (maybe/do
   (n <- (ffi:next-html-select iter-ptr))
   (Element n)))

(define/curry/contract (*html-iter->elemnet-list xs iter)
  (-> (listof Element?) Html-Iter? (listof Element?))
  (match (try-next-html-select iter)
    [(Just el)
     (->> (list el)
          (concat xs it)
          (*html-iter->elemnet-list it iter))]
    [_ xs]))

(define/contract html-iter->element-list
  (-> Html-Iter? (listof Element?))
  (*html-iter->elemnet-list empty))
