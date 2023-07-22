zubat
=====

![zubat](https://media.52poke.com/wiki/archive/d/da/20140405224319%21041Zubat.png)

这是一款实实在的html5解析库，仅作解析，不作html的修改、删除操作。
是[golbat](https://github.com/kalxd/golbat)的racket包装实现。

作为私人专用包，不再发布到racket package。

# 设计方法
详见这一篇文章：[Racket调用Rust若干想法](https://kalxd.github.io/%E7%AC%94%E8%AE%B0/pdf/racket%E8%B0%83%E7%94%A8rust%E7%9A%84%E8%8B%A5%E5%B9%B2%E6%83%B3%E6%B3%95.pdf)

# 安装
在安装此项目之前，需要先编译出[golbat][golbat]动态库，根据

```racket
(require setup/dirs)

(find-user-lib-dir)
;; 或者
(get-lib-search-dirs)
```

上面提示的路径，把动态库放置进去。

最后clone该项目：

```bash
$ git clone https://github.com/kalxd/zubat.git
$ cd zubat
$ raco pkg install
```

# 使用协议
* AGPL v3

[golbat]: https://github.com/kalxd/golbat
