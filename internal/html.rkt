#lang azelf

(require (only-in ffi/unsafe ctype? cpointer?)
         (prefix-in ffi: "./ffi/html.rkt")
         (prefix-in ffi: "./ffi/selector.rkt")
         "./element.rkt")

(provide (all-defined-out))

(struct Html [ptr])

(define/contract string->html
  (-> string? Html?)
  (>-> ffi:parse-html Html))

(define/contract string->fragment
  (-> string? Html?)
  (>-> ffi:parse-fragment Html))

(define/contract (try/html-select-next select-ptr)
  (-> cpointer? (Maybe/c Element?))
  (->> (ffi:html-select-next select-ptr)
       ->maybe
       (map Element)))

(define/curry/contract (fold/html-select xs select-ptr)
  (-> (Array/c Element?)
      cpointer?
      (Array/c Element?))
  (match (try/html-select-next select-ptr)
    [(Just el-ptr)
     (->> (Element el-ptr)
          (<:> it xs)
          (fold/html-select it select-ptr))]
    [_ xs]))

(define/contract html-select->array
  (-> cpointer? (Array/c Element?))
  (fold/html-select empty))

(define/curry/contract (html-query selector doc)
  (-> string? Html? (Array/c Element?))
  (define selector-ptr (ffi:build-selector selector))
  (->> (Html-ptr doc)
       (ffi:html-select it selector-ptr)
       html-select->array))

(define/curry/contract (html-query1 selector doc)
  (-> string? Html? (Maybe/c Element?))
  (define selector-ptr (ffi:build-selector selector))
  (->> (Html-ptr doc)
       (ffi:html-select it selector-ptr)
       try/html-select-next))
