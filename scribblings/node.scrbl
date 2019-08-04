#lang scribble/manual

@require[@for-label[zubat sxml racket]]

@title{元素解析}

@racket[zubat]只提供解析功能，并没有修改、删除功能。

@section{元素属性}

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

@section{元素查找}

@defproc[(zubat:child? [root sxml:element?]) boolean?]{
	该元素下是否有子元素。
}

@defproc[(zubat:child [root sxml:element?]) (maybe/c sxml:element?)]{
	获取第一个子元素。
}

@defproc[(zubat:all [root sxml:elements?]) nodeset?]{
	获取所有子元素，与@racket[zubat:children]不同在于，它递归得到每个元素的子元素，之后得到一条包含所有子元素的列表。
}

@defproc[(zubat:select [f (-> sxml:element? boolean?)] [root sxml:element?]) (listof sxml:element?)]{
	从所有子元素中过滤所需要的元素。
}

@defproc[(zubat:select-first [f (-> sxml:element? boolean?)] [root sxml:element?]) (maybe/c sxml:element?)]{
	从所有子元素中过滤得到第一个元素。
}

@defproc[(zubat:select-id [id string?] [root sxml:element?]) (maybe/c sxml:element?)]{
	传说中的@bold{getElementById}。
}

@defproc[(zubat:parent [root sxml:element?] [el sxml:element?]) (maybe/c sxml:element?)]{
	元素的上一级元素。
}

@defproc[(zubat:ancestor [root sxml:element?] [el sxml:element?]) (listof sxml:element?)]{
	元素的递归上级元素，即祖先链。
}

@defproc[(zubat:siblings [root sxml:element?] [el sxml:element?]) (listof sxml:element?)]{
	同级元素。
}
