type btnode =
  | Leaf
  | Node of string * btnode * btnode

val fibonacci: int -> int

val max: int -> int -> int

val increment_all: int list -> int list

val inorder_str: btnode -> string

val size: btnode -> int

val height: btnode -> int

val long_strings: string list -> int -> string list

val every_other: 'a list -> 'a list

val sum_all: int list list-> int list

val sum_of_squares: (int * int) list -> int

val remainders: int list -> int -> (int * int) list

val mean: int list -> int option

val list_max: int list -> int option
