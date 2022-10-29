#lang azelf

(require (only-in racket/port
                  port->string)
         (prefix-in ffi: "./internal/ffi.rkt"))

(export-from "./internal/util.rkt")

(define/contract string->html
  (-> string? Html?)
  (>-> ffi:parse-html
       Html))

(define/contract input-port->html
  (-> input-port? Html?)
  (>-> port->string
       string->html))

(define/contract string->fragment
  (-> string? Html?)
  (>-> ffi:parse-fragment
       Html))

(define/contract input-port->fragment
  (-> input-port? Html?)
  (>-> port->string
       string->fragment))

(define/curry/contract (query-html query-path html)
  (-> string? Html? (listof Element?))
  (match-define (Html html-ptr) html)
  (define selector-ptr (ffi:build-selector query-path))
  (define iter (->> (ffi:html-select html-ptr selector-ptr)
                    Html-Iter))
  (html-iter->element-list iter))

(define/curry/contract (query-html1 query-path html)
  (-> string? Html? (Maybe/c Element?))
  (->> (query-html query-path html)
       head))

(define/curry/contract (query-element query-path el)
  (-> string? Element? (listof Element?))
  (match-define (Element element-ptr) el)
  (define selector-ptr (ffi:build-selector query-path))
  (define iter (->> (ffi:element-select element-ptr selector-ptr)
                    Element-Iter))
  (element-iter->element-list iter))

(define/curry/contract (query-element1 query-path el)
  (-> string? Element? (Maybe/c Element?))
  (->> (query-element query-path el)
       head))

(define/match1/contract element-id
  (-> Element? (Maybe/c string?))
  [(Element ptr)
   (->maybe (ffi:element-id ptr))])

(define/match1/contract element-name
  (-> Element? string?)
  [(Element ptr) (ffi:element-name ptr)])

(define/match1/contract element-html
  (-> Element? string?)
  [(Element ptr) (ffi:element-html ptr)])

(module+ test
  (require racket/file)

  (define html
    (->> (file->string "./sample.html")
         string->html))

  (displayln (maybe/do
              (n <- (query-html1 "#page" html))
              (n <- (query-element1 "p.line862" n))
              (element-html n))))
