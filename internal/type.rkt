#lang azelf

(require/typed ffi/unsafe
  [#:opaque CType ctype?])

(provide CType)
