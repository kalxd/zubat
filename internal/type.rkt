#lang azelf

(require/typed ffi/unsafe
  [#:opaque CType ctype?]
  [#:opaque CPointer cpointer?])

(provide CType
         CPointer)
