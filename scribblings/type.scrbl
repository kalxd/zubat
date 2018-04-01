#lang scribble/manual

@title{基本类型}

@defproc[(maybe/c [a any/c]) (or/c #f any/c)]{

	Maybe类型，一个值可能为空(@racket[#f])或是其它值(@racket[any/c])。
}
