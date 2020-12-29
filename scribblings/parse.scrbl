#lang scribble/manual

@require[@for-label[racket zubat sxml]]

@title{解析它！}

zubat解析利用html-parsing这个库进行解析。

@defproc[(input->sxml [port input-port?]) sxml:element?]{
	读取@racket[input-port]，转化成sxml。
}
