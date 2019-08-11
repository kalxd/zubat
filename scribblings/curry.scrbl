#lang scribble/manual

@title{柯里化}

@require[@for-label[racket zubat]]

本库同样提供全套柯里化服务。默认以@racket[curryr]形式柯里化，以便在特定场景使用。

@racketblock[

;; 柯里化库在zubatr，不与zubat同包。
(require (prefix-in zubat: zubat/curry))

(define link-id (compose (zubat:select-id "link") (zubat:node-id)))

(link-id el)

]
