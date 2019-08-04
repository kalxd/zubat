#lang scribble/manual

@require[@for-label[zubat sxml racket]]

@title{查找元素}

@italic{样式以后再说罢。}

@defproc[(node-children [el sxml:element?]) nodeset?]{
	获取该元素下一级的所有子元素。
}
