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

% op_prec(+Op, -Precedence)
% Precedence levels: * and / bind tighter (2) than + and - (1).
op_prec('+', 1).
op_prec('-', 1).
op_prec('*', 2).
op_prec('/', 2).

% expr_to_string(+Expr, -String)
% True when String is the canonical SWI-Prolog string representation of Expr,
% with no spaces and parentheses applied according to precedence and left-associativity.
expr_to_string(N, String) :-
    integer(N),
    !,
    number_string(N, String).
expr_to_string(Expr, String) :-
    Expr =.. [Op, Left, Right],
    op_prec(Op, OpPrec),
    format_child(left, OpPrec, Left, LeftStr),
    format_child(right, OpPrec, Right, RightStr),
    atom_string(Op, OpStr),
    string_concat(LeftStr, OpStr, Temp),
    string_concat(Temp, RightStr, String).

% format_child(+Position, +ParentPrec, +ChildExpr, -ChildString)
% Formats a child expression, enclosing in parentheses if precedence or associativity requires it.
format_child(_, _, N, String) :-
    integer(N),
    !,
    number_string(N, String).
format_child(left, ParentPrec, ChildExpr, String) :-
    ChildExpr =.. [ChildOp, _, _],
    op_prec(ChildOp, ChildPrec),
    expr_to_string(ChildExpr, SubStr),
    (   ChildPrec < ParentPrec
    ->  string_concat("(", SubStr, S1),
        string_concat(S1, ")", String)
    ;   String = SubStr
    ).
format_child(right, ParentPrec, ChildExpr, String) :-
    ChildExpr =.. [ChildOp, _, _],
    op_prec(ChildOp, ChildPrec),
    expr_to_string(ChildExpr, SubStr),
    (   ChildPrec =< ParentPrec
    ->  string_concat("(", SubStr, S1),
        string_concat(S1, ")", String)
    ;   String = SubStr
    ).

% equation_to_string(+ExprL, +ExprR, -EqString)
% True when EqString is the canonical SWI-Prolog string of the equation ExprL = ExprR.
equation_to_string(ExprL, ExprR, EqString) :-
    expr_to_string(ExprL, StrL),
    expr_to_string(ExprR, StrR),
    string_concat(StrL, "=", Temp),
    string_concat(Temp, StrR, EqString).
