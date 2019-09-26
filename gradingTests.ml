open OUnit2
let max a b = failwith "max must be implemented in functions.ml"
open Functions

let t_fint tname expected fn arg =
  tname>:: (fun _ -> (assert_equal expected (fn arg) ~printer:string_of_int))

let t_int tname expected gotten =
  tname>:: (fun _ -> (assert_equal expected gotten ~printer:string_of_int))

let t_string_list tname expected gotten =
  tname>::(fun _ -> assert_equal expected gotten
     ~printer:(List.fold_left (fun acc el -> acc ^ el) ""))

let t_string tname expected gotten =
  tname>::(fun _ -> assert_equal expected gotten)

let t_int_list tname expected gotten =
  tname>::(fun _ -> assert_equal expected gotten
            ~printer:(fun lst ->
              List.fold_left
                (fun acc x -> acc ^ "(" ^ (string_of_int x) ^ ");") "" lst))

let t_int_pair_list tname expected gotten =
  tname>::(fun _ -> assert_equal expected gotten
            ~printer:(fun lst ->
              List.fold_left
                (fun acc (a,b) -> acc ^ "(" ^ (string_of_int a) ^ "," ^
                                  (string_of_int b) ^ ");") "" lst))

let t_int_option tname expected gotten =
  tname>::(fun _ -> assert_equal expected gotten
            ~printer:(fun opt -> match opt with
              | None -> "None"
              | Some x -> "Some(" ^ (string_of_int x) ^ ")"))

let sum l = List.fold_left (+) 0 l

let fibonacci_tests = "fibonacci tests">:::[
  t_fint "zero case" 1 fibonacci 0;
  t_fint "one case" 1 fibonacci 1;
  t_fint "one recurse" 2 fibonacci 2;
  t_fint "larger val" 8 fibonacci 5;
]

let max_tests = "max tests">:::[
  t_int "equal max" 5 (max 5 5);
  t_int "first smaller" 5 (max 4 5);
  t_int "second smaller" 4 (max 4 3);
  t_int "negative nums" (-2) (max (-2) (-12));
  t_int "zero case" 500 (max 500 0);
]

let bt_leaf = Leaf
let bt_node = Node("a", Leaf, Leaf)
let bt_node_lc = Node("b", Node("a", Leaf, Leaf), Leaf)
let bt_node_rc = Node("a", Leaf, Node("b", Leaf, Leaf))
let bt_node_lrc = Node("b", Node("a", Leaf, Leaf), Node("c", Leaf, Leaf))
let bt_node_lrc2 = Node("c", Node("b", Node("a", Leaf, Leaf), Leaf), Node("d", Leaf, Leaf))
let bt_node_lrc3 = Node("b", Node("a", Leaf, Leaf), Node("c", Leaf, Node("d", Leaf, Leaf)))

let tree_inorder_str_tests = "tree inorder tests">:::[
  t_string "just a leaf" "" (inorder_str bt_leaf);
  t_string "one node" "a" (inorder_str bt_node);
  t_string "node with left child" "ab" (inorder_str bt_node_lc);
  t_string "node with right child" "ab" (inorder_str bt_node_rc);
  t_string "node with two children" "abc" (inorder_str bt_node_lrc);
]

let tree_size_tests = "tree size tests">:::[
  t_int "just a leaf" 0 (size bt_leaf);
  t_int "one node" 1 (size bt_node);
  t_int "node with left child" 2 (size bt_node_lc);
  t_int "node with right child" 2 (size bt_node_rc);
  t_int "node with two children" 3 (size bt_node_lrc);
]

let tree_height_tests = "tree height tests">:::[
  t_int "just a leaf" 0 (height bt_leaf);
  t_int "one node" 1 (height bt_node);
  t_int "node with left child" 2 (height bt_node_lc);
  t_int "node with right child" 2 (height bt_node_rc);
  t_int "node with two children" 2 (height bt_node_lrc);
  t_int "node with taller left subtree" 3 (height bt_node_lrc2);
  t_int "node with taller right subtree" 3 (height bt_node_lrc3);
]

let increment_tests = "list increment tests">:::[
  t_int_list "increment_all empty" [] (increment_all []);
  t_int_list "increment_all one element" [-2] (increment_all [-3]);
  t_int_list "increment_all zeros" [1; 1; 1; 1; 1] (increment_all [0; 0; 0; 0; 0]);
  t_int_list "increment_all nums" [21; 31; 41] (increment_all [20; 30; 40]);
]
let long_strings_tests = "list long strings tests">:::[
  t_string_list "long_strings empty" [] (long_strings [] 2);
  t_string_list "long_strings one element" ["yoo"] (long_strings ["yoo"] 2);
  t_string_list "long_strings less than int" [] (long_strings ["yoo"; "1234"; "ocaml"] 5);
  t_string_list "long_strings greater than int" ["yoo"; "1234"; "ocaml"] (long_strings ["yoo"; "1234"; "ocaml"] 2);
  t_string_list "long_strings mix" ["1234"; "ocaml"] (long_strings ["yoo"; "1234"; "ocaml"] 3);
]
let every_other_tests = "every other tests">:::[
  t_string_list "every_other empty" [] (every_other []);
  t_string_list "every_other one element" ["1"] (every_other ["1"]);
  t_string_list "every_other two element" ["1"] (every_other ["1"; "2"]);
  t_string_list "every_other multiple" ["1"; "3"; "5"] (every_other ["1"; "2"; "3"; "4"; "5"]);
  t_int_pair_list "every_other multiple pairlist" [(6,0); (-1,0)] (every_other [(6,0); (2,0); (-1,0)]);
]

let sum_all_tests = "list sum all tests">:::[
  t_int_list "sum_all empty" [0] (sum_all [[]]);
  t_int_list "sum_all one element in single list" [5] (sum_all [[5]]);
  t_int_list "sum_all mult element in single list" [8] (sum_all [[5; 2; 1]]);
  t_int_list "sum_all mult element in two lists" [8;0] (sum_all [[5; 2; 1];[-5;5]]);
  t_int_list "sum_all mult element in mult lists" [8;0;1;4] (sum_all [[5; 2; 1];[-5;5];[1];[1;1;1;1]]);
]

let sum_of_squares_tests = "sum of squares tests">:::[
  t_int "empty list sum of squares" 0 (sum_of_squares []);
  t_int "single element" 50 (sum_of_squares [(5,5)]);
  t_int "multiple elements, second non-zero" 50
    (sum_of_squares [(0,5); (0, 3); (0,4)]);
  t_int "multiple elements, first non-zero" 109
    (sum_of_squares [(8,0); (6, 0); (3,0)]);
  t_int "long list, negatives" 104
    (sum_of_squares [(-1, 4); (3, -7); (4, 2); (-3, 0)]);
]

let remainders_tests = "remainders tests">:::[
  t_int_pair_list "empty list remainders" [] (remainders [] 0);
  t_int_pair_list "single element list, no div" [(5,0)] (remainders [5] 1);
  t_int_pair_list "single element list, div" [(1,2)] (remainders [5] 3);
  t_int_pair_list "multiple element list, no div" [(6,0);(2,0);(-1,0)]
    (remainders [6; 2; -1] 1);
  t_int_pair_list "multiple element list, div" [(1,2);(0,2);(0,-1)]
    (remainders [6; 2; -1] 4);
  t_int_pair_list "multiple element list, greater list vals"
    [(1,2);(4,0);(6,1);(12,4);] (remainders [10; 32; 49; 100;] 8);
]

let option_mean_tests = "option mean tests">:::[
  t_int_option "empty list" None (mean []);
  t_int_option "single element list" (Some 1) (mean [1]);
  t_int_option "two element list" (Some 2) (mean [1;3]);
  t_int_option "three element list" (Some 2) (mean [1;2;3]);
  t_int_option "four element list" (Some 2) (mean [1;2;3;4]);
  t_int_option "list with all zeros" (Some 0) (mean [0;0;0]);
]

let option_list_max_tests = "option list max tests">:::[
  t_int_option "empty list" None (list_max []);
  t_int_option "single element list" (Some 1) (list_max [1]);
  t_int_option "two element list" (Some 2) (list_max [1;2]);
  t_int_option "three element list" (Some 3) (list_max [1;2;3]);
  t_int_option "list with max in middle" (Some 3) (list_max [1;3;2]);
  t_int_option "negative maximum" (Some (-1)) (list_max [-3;-2;-1]);
  t_int_option "list with all zeros" (Some 0) (list_max [0;0;0]);
]

let test_list = fibonacci_tests::max_tests::tree_inorder_str_tests::tree_size_tests::
                tree_height_tests::sum_of_squares_tests::remainders_tests::
                option_mean_tests::option_list_max_tests::increment_tests::
                long_strings_tests::every_other_tests::sum_all_tests::[]

let suite = "suite">:::test_list;;
run_test_tt_main suite
