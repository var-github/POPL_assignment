% tests/test_q2.pl
% Unit tests for Problem 2 (23_q2.pl)
% Run with: swipl -q -f tests/test_q2.pl -g run_tests -t halt

:- consult('../code/23_q2.pl').

% Test 1: generate_equation for [4,2,5,3] succeeds and gives one valid equation
test(generate_equation_4253) :-
    generate_equation([4,2,5,3], E),
    member(E, [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ]),
    !.

% Test 2: all_equations for [4,2,5,3] matches the 7 canonical equations in exact sorted order
test(all_equations_4253) :-
    all_equations([4,2,5,3], Es),
    Es == [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ].

% Test 3: count_equations for [4,2,5,3] gives 7
test(count_equations_4253) :-
    count_equations([4,2,5,3], 7).

% Test 4: generate_equation for [2,3,4] fails gracefully
test(generate_equation_234_fails) :-
    \+ generate_equation([2,3,4], _).

% Test 5: all_equations for [2,3,4] gives empty list []
test(all_equations_234_empty) :-
    all_equations([2,3,4], []).

% Test 6: count_equations for [2,3,4] gives 0
test(count_equations_234_zero) :-
    count_equations([2,3,4], 0).

% Test 7: all_equations for [2,4,8] gives ["2*4=8"]
test(all_equations_248) :-
    all_equations([2,4,8], ["2*4=8"]).

% Test 8: Edge case - empty list []
test(edge_case_empty_list) :-
    \+ generate_equation([], _),
    all_equations([], []),
    count_equations([], 0).

% Test 9: Edge case - single-element list [5]
test(edge_case_single_element) :-
    \+ generate_equation([5], _),
    all_equations([5], []),
    count_equations([5], 0).

% Test 10: Canonical string formatting & precedence rules
test(formatting_precedence_rules) :-
    expr_to_string('*'('+'(4, 2), 3), "(4+2)*3"),
    expr_to_string('+'(4, '*'(2, 3)), "4+2*3"),
    expr_to_string('*'('/'(8, 4), 2), "8/4*2"),
    expr_to_string('/'(8, '*'(4, 2)), "8/(4*2)"),
    expr_to_string('-'('-'(1, 2), 3), "1-2-3"),
    expr_to_string('-'(1, '-'(2, 3)), "1-(2-3)"),
    expr_to_string('+'(1, '+'(2, 3)), "1+(2+3)"),
    expr_to_string('+'('+'(1, 2), 3), "1+2+3").

% Test 11: Division constraints - non-integer division rejected
% 6/2 is exact (succeeds with 3), while 5/2 has remainder and must fail
test(division_exactness) :-
    build_expr([6, 2], '/'(6, 2), 3),
    \+ build_expr([5, 2], '/'(5, 2), _).

% Test 12: Division by zero rejected
test(division_by_zero) :-
    % Direct division by zero must fail
    \+ build_expr([4, 0], '/'(4, 0), _),
    % Division by an expression evaluating to zero must fail
    \+ build_expr([4, 2, 2], '/'(4, '-'(2, 2)), _).

% Runner predicate
run_test_case(Name) :-
    (   test(Name)
    ->  format('  [PASS] ~w~n', [Name])
    ;   format('  [FAIL] ~w~n', [Name]),
        fail
    ).

run_tests :-
    writeln('Running P2 Unit Tests:'),
    AllTests = [
        generate_equation_4253,
        all_equations_4253,
        count_equations_4253,
        generate_equation_234_fails,
        all_equations_234_empty,
        count_equations_234_zero,
        all_equations_248,
        edge_case_empty_list,
        edge_case_single_element,
        formatting_precedence_rules,
        division_exactness,
        division_by_zero
    ],
    forall(member(T, AllTests), run_test_case(T)),
    writeln('All P2 unit tests passed successfully!').
