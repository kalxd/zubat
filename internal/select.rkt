#lang azelf

(require "./ffi/select.rkt"
         "./element.rkt"
         (only-in ffi/unsafe cpointer?))

(provide (all-defined-out))

(define/curry/contract (try/html-select-next select-ptr)
  (-> cpointer? (Maybe/c Element?))
  (->> (html-select-next select-ptr)
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
