type btnode =
  | Leaf
  | Node of string * btnode * btnode

let rec fib n =
  if n < 2 then 1 else fib (n - 1) + fib (n - 2)

let min a b = if a < b then a else b


let increment_all l =
  List.map (fun x -> x + 1) l

let long_strings l n =
  List.fold_left (fun a x -> if String.length x > n then a @ [x] else a) [] l

let every_other l =
  snd (List.fold_left (fun (b,l) x -> if b then (false, l @ [x]) else (true, l)) (true, []) l)

let max a b = if a < b then b else a

let rec inorder_str t =
  match t with
  | Leaf -> ""
  | Node(s, l, r) -> (inorder_str l) ^ s ^ (inorder_str r)

let rec size t =
  match t with
  | Leaf -> 0
  | Node(_, l, r) -> 1 + (size l) + (size r)

let rec height t =
  match t with
  | Leaf -> 0
  | Node(_, l, r) -> 1 + max (height l) (height r)

let sum_of_squares lst =
  List.fold_left (fun sum (a,b) -> (a*a) + (b*b) + sum) 0 lst

let remainders lst dividend =
  List.map (fun elem -> (elem / dividend),(elem mod dividend)) lst

let sum_all lst_of_lst =
  List.map
    (fun sublst -> List.fold_left (+) 0 sublst) lst_of_lst

let mean l =
  match List.length l with
  | 0 -> None
  | x -> Some ((List.fold_left (+) 0 l) / x)

let list_max l =
  match List.length l with
  | 0 -> None
  | _ -> Some (List.fold_left max (List.hd l) l)
