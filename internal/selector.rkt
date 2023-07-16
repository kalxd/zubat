#lang azelf

(require "./ffi/selector.rkt")
(provide (all-defined-out))

(struct Selector [ptr])

(define/contract string->selector
  (-> string? Selector?)
  (>-> build-selector Selector))
