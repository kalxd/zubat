#lang racket/base

(provide file->sxml
         inport->sxml)

(require racket/list
         racket/file
         html-parsing
         sxml)

;; 解析文件
(define file->sxml
  (compose html->xexp
           (λ (path) (file->string path #:mode 'text))))

(define inport->sxml html->xexp)
