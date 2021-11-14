#lang scribble/manual

@require[@for-label[zubat sxml azelf racket/string]]

@title{元素属性}

@defproc[(node-attr [attr symbol?] [el sxml:element?]) (Maybe/c string?)]{
查找元素某个属性。由于是从网页上攫取下来的属性，它只能是@racket[string]类型，而且会自动@racket[string-trim]一遍。
}

@defproc[(node-attr? [attr symbol?] [el sxml:element?]) boolean?]{
元素是否存在某个属性。
}

@defproc[(node-text [el sxml:element?]) string?]{
元素文本。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-text el) ;; "main text"
}|

@defproc[(node-tag [el sxml:element?]) string?]{
元素标签名称。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-tag el) ;; "main"
}|

@defproc[(node-id [el sxml:element?]) (Maybe/c string?)]{
获取元素的id。
}

@defproc[(node-id? [id string?] [el sxml:element?]) boolean?]{
检查元素是否有相应的id。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-id? "main-id" el) ;; #t
	(node-id? "main" el) ;; #f
}|

@defproc[(node-class [el sxml:element?]) (listof string?)]{
获取元素class，以列表形式输出。
}

@codeblock|{
	(define el '(div (@ (class "button")) "primary button"))
	(node-class el) ;; '("button")
	(define el '(main (@ (id "main-id")) "main text"))
	(node-class el) ;; '()
}|

@defproc[(node-class? [name string?] [el sxml:element?]) boolean?]{
元素是否包含某个class。
}

@codeblock|{
	(define el '(div (@ (class "button")) "primary button"))
	(node-class? "button" el) ;; #t
	(node-class? "input" el) ;; #f
}|

@defproc[(node-href [el sxml:element?]) (Maybe/c string?)]{
找出元素的链接。
}

@defproc[(node-value [el sxml:element?]) (Maybe/c string?)]{
element.value
}
