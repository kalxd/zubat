#lang scribble/manual
@require[@for-label[zubat
		    racket/base]]

@title{zubat}
@author{XG.Ley}

@defmodule[zubat]

纵观现有的库，尚未发现能足够好用地解析HTML5页面，sxml是一个XML解析库，它提供了基本方法，一些HTML5特有的解析方式却需要重新实现。

在@racket[sxml]的基础上，实现了一些比较常用的功能，例如@bold{document.getElementById}。需要注意的是，zubat并没有@bold{document.querySelector}，因为我没有css selector解析库。

@include-section["type.scrbl"]

@include-section["parse.scrbl"]

@include-section["element.scrbl"]
