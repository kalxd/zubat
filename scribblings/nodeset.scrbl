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

@defproc[(node-all-children [root (or/c empty? sxml:elements?)]) nodeset?]{
	获取所有子元素，与@racket[node-children]不同在于，它深度遍历得到每个元素的子元素，得到一条包含所有子元素的列表。
}
