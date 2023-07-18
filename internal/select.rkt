#lang azelf

(require "./ffi/select.rkt"
         "./element.rkt"
         (only-in ffi/unsafe cpointer?))

(provide (all-defined-out))

(define/curry/contract (try/html-select-next select-ptr)
  (-> cpointer? (Maybe/c ElementRef?))
  (->> (html-select-next select-ptr)
       ->maybe
       (map ElementRef)))

(define/curry/contract (fold/html-select xs select-ptr)
  (-> (Array/c ElementRef?)
      cpointer?
      (Array/c ElementRef?))
  (match (try/html-select-next select-ptr)
    [(Just el-ptr)
     (->> (ElementRef el-ptr)
          (<:> it xs)
          (fold/html-select it select-ptr))]
    [_ xs]))

(define/contract html-select->array
  (-> cpointer? (Array/c ElementRef?))
  (fold/html-select empty))
