#lang scribble/manual

@require[@for-label[racket zubat]]

@title{介绍}

纵观现有的库，尚未发现能足够好用的HTML5解释器，sxml是一个XML解析库，它提供了基本方法，一些HTML5特有的解析方式却需要重新实现，为了查找到一个元素需要费一番周折。

在@racket[sxml]的基础上，实现了一些比较常用的功能，例如@bold{document.getElementById}。
使用该库需要注意以下几点：

@itemlist[
	@item{zubat没有@bold{document.querySelector}，只有类似的@racket[node-select]。}
	@item{zubat内部命名可能会与@racket[sxml]重名，最好能通过前缀区分它们。}
]
