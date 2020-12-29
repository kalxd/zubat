#lang racket/base

(provide (all-from-out "./zubat/node.rkt")
         (all-from-out "./zubat/nodeset.rkt")
         (all-defined-out))

(require racket/contract
         sxml
         html-parsing

         "./zubat/node.rkt"
         "./zubat/nodeset.rkt")

;; 从一个输入口导出sxml。
(define/contract (input->sxml input)
  (-> (or/c input-port? string?) sxml:element?)
  (html->xexp input))
