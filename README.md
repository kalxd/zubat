zubat
=====

HTML5解析库，在`sxml`基础之上封装一层，接口更加简单。

使用
----

```racket
(require zubat)

(zubat:select-id "main" root) ;; 选择id为main的元素
(zubat:children main) ;; main元素下所有子元素（不包含子元素之下的子元素——孙子一层元素）
```

该包下面的函数皆以`zubat:`开头。

使用协议
--------

* GPL v3
* AGPL v3
