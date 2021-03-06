#lang scribble/manual

@require[@for-label[zubat sxml racket]]

@title{元素属性}

@defproc[(node-attr [el sxml:element?] [attr symbol?]) (or/c #f string?)]{
	查找元素某个属性。由于是从网页上攫取下来的属性，它只能是@racket[string]类型，而且会自动@racket[string-trim]一遍。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-attr el 'id) ;; -> "main-id"
	(node-attr el 'class) ;; #f
}|

@defproc[(node-attr? [el sxml:element?] [attr symbol?]) boolean?]{
	元素是否存在某个属性。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-attr? el 'id) ;; #t
	(node-attr? el 'class) ;; #f
}|

@defproc[(node-text [el sxml:element?]) string?]{
	元素文本。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-text el) ;; "main text"
}|

@defproc[(node-tag-name [el sxml:element?]) string?]{
	元素标签名称。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-tag-name el) ;; "main"
}|

@defproc[(node-id [el sxml:element?]) (or/c #f string?)]{
	获取元素的id，id可能不存在，所以可能会返回@racket[#f]。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-id el) ;; "main-id"
	(define el '(main (@ (class "main-id")) "main text"))
	(node-id el) ;; #f
}|

@defproc[(node-id? [el sxml:element?] [id string?]) boolean?]{
	检查元素是否有相应的id。
}
@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(node-id? el "main-id") ;; #t
	(node-id? el "main") ;; #f
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

@defproc[(node-class? [el sxml:element?] [name string?]) boolean?]{
	元素是否包含某个class。
}

@codeblock|{
	(define el '(div (@ (class "button")) "primary button"))
	(node-class? el "button") ;; #t
	(node-class? el "input") ;; #f
}|

@defproc[(node-href [el sxml:element?]) (or/c #f url?)]{
找出元素的链接。
}
