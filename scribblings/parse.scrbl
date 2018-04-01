#lang scribble/manual

@(require (for-label zubat))

@title{解析它！}

zubat解析利用html-parsing这个库进行解析。

@section{inport->html}

将一个@racket['inport]转换成@racket[sxml]。

@section{file->sxml}

将本地文件直接解析成@racket[sxml]。

@racketblock[
(file->sxml "sample.html")
]
