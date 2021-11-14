#lang scribble/manual

@require[@for-label[racket zubat sxml]]

@title{解析它！}

@defproc[(html:parse [port (or/c input-port? string?)]) sxml:element?]{
@racket[html->xexp]别名。
}
