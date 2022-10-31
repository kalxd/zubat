#lang scribble/manual

@require[@for-label[azelf zubat]]

@title{zubat}

@defmodule[zubat]

@section[#:tag "intro"]{开场白}

这一个胶水胶起来的html5解析库，自身没有解析能力，需要依靠（FFI）rust。

整体抛弃了@hyperlink{https://docs.racket-lang.org/html-parsing/index.html @literal{html-parsing}}，作为html5解析库，使用css selector明显更加合理。

换句话说，这个库从底层的@hyperlink{https://docs.racket-lang.org/html-parsing/index.html @literal{html-parsing}}换到了@hyperlink{https://github.com/kalxd/golbat @literal{golbat}}。使用前需要编译这个rust项目，将生成的动态库libgolbat.so复到到racket的库目录中。

可以使用@racket[current-library-collection-links]找到动态库路径。

@section[#:tag "html-parser"]{HTML文档解析}

@defproc*[([(string->html [content string?]) Html?]
		   [(input-port->html [port input-port?]) Html?])]{
将@racket[string?]或@racket[input-port?]转化为@racket[Html?]文档。
}

@defproc*[([(string->fragment [content string?]) Html?]
		   [(input-port->fragment [port input-port?]) Html?])]{
效果与@racket[string->html]相同，不同在于它只能解析html片段，无法解析整张网页。
}

@defproc*[([(query-html [query-path string?] [html Html?]) (listof Element?)]
		   [(query-html1 [query-path string?] [html Html?]) (Maybe/c Element?)])]{
利用css selector查询元素。
}

@defproc*[([(query-element [query-path string?] [el Element?]) (listof Element?)]
		   [(query-element1 [query-path string?] [el Element?]) (Maybe/c Element?)])]{
同@racket[query-html]，仅查询主体不同。
}

@defproc*[([(element-html [el Element?]) string?]
		   [(element-inner-html [el Element?]) string?])]{
}

@defproc*[([(element-text [el Element?]) (listof string?)]
		   [(element-text1 [el Element?]) (Maybe/c string?)])]{
元素的text，@racket[element-text]会显示所有子元素的text。
}

@defproc[(element-id [el Element?]) (Maybe/c string?)]{
元素的id。
}

@defproc[(element-name [el Element?]) (Maybe/c string?)]{
元素的tagname。
}

@defproc*[([(elemnet-class [el Element?]) (listof string?)]
		   [(elemnet-class1 [el Element?]) (Maybe/c string?)])]{
元素的class。
}

@defproc[(element-attr1 [el Element?]) (Maybe/c string?)]{
元素的attribute。
}

@section[#:tag "type"]{基本类型}

@defthing[Html? 文档]{}
@defthing[Element? 文档结点，或称之为元素]{}
