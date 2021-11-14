#lang scribble/manual

@require[@for-label[azelf zubat sxml]]

@title{查找元素}

@italic{样式以后再说罢。}

@defproc[(node-children [root sxml:element?]) nodeset?]{
	获取该元素下一级的所有子元素。
}

@defproc[(node-children? [root sxml:element?]) boolean?]{
	该元素下是否有子元素。
	或者该元素是否为叶子节点。
}

@defproc[(node-first-child [root sxml:element?]) (Maybe/c sxml:element?)]{
	获取第一个子元素。
}

@defproc[(node-all-children [root sxml:elements?]) nodeset?]{
	获取所有子元素，与@racket[node-children]不同在于，它深度遍历得到每个元素的子元素，得到一条包含所有子元素的列表。
}

@defproc[(node-search-by [f (-> sxml:element? boolean?)] [root sxml:element?]) nodeset?]{
从所有子元素中过滤所需要的元素。

类似于@bold{querySelectorAll}，只是@racket[node-select]接受的是一个高阶函数，不是选择器。
}

@defproc[(node-search-first-by [f (-> sxml:element? boolean?)] [root sxml:element?]) (Maybe/c sxml:element?)]{
从所有子元素中过滤得到第一个元素。
}

@defproc[(node-by-id [id string?] [root sxml:element?]) (Maybe/c sxml:element?)]{
传说中的@bold{getElementById}。
}

@defproc[(node-by-class [class string?] [root sxml:element?]) nodeset?]{
找出包含class的所有元素。
}

@defproc[(node-first-by-class [class string?] [root sxml:element?]) (Maybe/c sxml:element?)]{
找出第一个包含该class的元素。
}
