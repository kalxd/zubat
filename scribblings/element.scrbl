#lang scribble/manual

@require[@for-label[zubat sxml racket]]

@title{元素解析}

@racket[zubat]只提供解析功能，并没有修改、删除功能。

@section{元素属性}

@defproc[(zubat:attr [attr symbol?] [el sxml:element?]) (maybe/c string?)]{
	查找元素某个属性。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(zubat:attr 'id el) ;; -> "main-id"
}|

@defproc[(zubat:attr? [att symbol?] [el sxml:element?]) boolean?]{
	元素是否存在某个属性。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(zubat:attr? 'id el) ;; #t
	(zubat:attr? 'class el) ;; #f
}|

@defproc[(zubat:text [el sxml:element?]) string?]{
	元素文本。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(zubat:text el) ;; "main text"
}|

@defproc[(zubat:tag [el sxml:element?]) string?]{
	元素标签名称。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(zubat:tag el) ;; "main"
}|


@defproc[(zubat:id [el sxml:element?]) (maybe/c string?)]{
	获取元素的id，id可能不存在，所以可能会返回@racket[#f]。
}

@codeblock|{
	(define el '(main (@ (id "main-id")) "main text"))
	(zubat:id el) ;; "main-id"
}|

@defproc[(zubat:class [el sxml:element?]) (listof string?)]{
	获取元素class，以列表形式输出。
}

@codeblock|{
	(define el '(div (@ (class "button")) "primary button"))
	(zubat:class el) ;; '("button")
}|

@defproc[(zubat:class? [name string?] [el sxml:element?]) boolean?]{
	元素是否包含某个class。
}

@codeblock|{
	(define el '(div (@ (class "button")) "primary button"))
	(zubat:class? "button" el) ;; #t
	(zubat:class? "input" el) ;; #f
}|

@section{元素查找}

@defproc[(zubat:children [root (or/c empty? sxml:element?)]) nodeset?]{
	获取该元素下一级的所有子元素。
}

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
