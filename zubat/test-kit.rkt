(module test+ racket
  (provide (all-defined-out)
           (all-from-out racket)
           (all-from-out rackunit)
           (all-from-out racket/trace))

  (require rackunit
           racket/list
           racket/trace)

  (define-simple-check (check-empty? v)
    (empty? v))

  (define-simple-check (check-length? n xs)
    (equal? n (length xs))))
