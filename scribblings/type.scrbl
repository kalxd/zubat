#lang scribble/manual

@require[@for-label[scribble/srcdoc
		    racket/contract]]

@title{基本类型}

@defproc[(maybe/c [a any/c]) (or/c #f any/c)]{
	Maybe类型，一个值可能为空(@racket[#f])或是其它值(@racket[any/c])。
}

除此之外，还有一些其它库中包含的类型，主要以@racket[sxml]为主。
