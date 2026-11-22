:- use_module(library(lists)).

% split_list(+List, -Left, -Right)
% True when Left and Right are non-empty lists such that their concatenation is List.
split_list(List, Left, Right) :-
    append(Left, Right, List),
    Left = [_|_],
    Right = [_|_].

% build_expr(+List, -Expr, -Val)
% True when Expr is a valid arithmetic expression tree formed by placing +, -, *, /
% between the numbers in List in their given order, and Val is the exact integer
% value of Expr. All divisions must be exact (zero remainder) with non-zero divisors.
build_expr([N], N, N) :-
    integer(N),
    N >= 0.
build_expr(List, +(ExprL, ExprR), Val) :-
    split_list(List, Left, Right),
    build_expr(Left, ExprL, ValL),
    build_expr(Right, ExprR, ValR),
    Val is ValL + ValR.
build_expr(List, -(ExprL, ExprR), Val) :-
    split_list(List, Left, Right),
    build_expr(Left, ExprL, ValL),
    build_expr(Right, ExprR, ValR),
    Val is ValL - ValR.
build_expr(List, *(ExprL, ExprR), Val) :-
    split_list(List, Left, Right),
    build_expr(Left, ExprL, ValL),
    build_expr(Right, ExprR, ValR),
    Val is ValL * ValR.
build_expr(List, /(ExprL, ExprR), Val) :-
    split_list(List, Left, Right),
    build_expr(Left, ExprL, ValL),
    build_expr(Right, ExprR, ValR),
    ValR =\= 0,
    ValL rem ValR =:= 0,
    Val is ValL // ValR.
