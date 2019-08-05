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

@defproc[(node-select [root (or/c empty? sxml:element?)] [f (-> sxml:element? boolean?)]) nodeset?]{
	从所有子元素中过滤所需要的元素。

	类似于@bold{querySelectorAll}，只是@racket[node-select]接受的是一个高阶函数，不是选择器。
}

@defproc[(node-select-first [root (or/c empty? sxml:element?)] [f (-> sxml:element? boolean?)]) (or/c #f sxml:element?)]{
	从所有子元素中过滤得到第一个元素。
}
