#lang scribble/manual

@require[@for-label[zubat sxml racket]]

@title{查找元素}

@italic{样式以后再说罢。}

@defproc[(node-children [el (or/c emtpy? sxml:element?)]) nodeset?]{
	获取该元素下一级的所有子元素。
}

@defproc[(node-children? [root (or/c empty? sxml:element?)]) boolean?]{
	该元素下是否有子元素。
	或者该元素是否为叶子节点。
}

@defproc[(node-child [root (or/c empty? sxml:element?)]) (or/c #f sxml:element?)]{
	获取第一个子元素。
}
