#lang azelf

(require (only-in racket/port
                  port->string)
         (prefix-in ffi: "./internal/ffi.rkt")
         "./internal/util.rkt")

(define/contract string->html
  (-> string? Html?)
  (>-> ffi:parse-html
       Html))

(define/contract input-port->html
  (-> input-port? Html?)
  (>-> port->string
       string->html))

(define/contract (query-html query-path html)
  (-> string? Html? (listof Element?))
  (match-define (Html html-ptr) html)
  (define selector-ptr (ffi:build-selector query-path))
  (define iter (->> (ffi:html-select html-ptr selector-ptr)
                    Html-Iter))
  (html-iter->element-list iter))
