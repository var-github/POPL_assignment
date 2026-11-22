% tests/test_q1.pl
% Unit tests for Problem 1 (23_q1.pl)
% Run with: swipl -q -f tests/test_q1.pl -g run_tests -t halt

:- consult('../code/23_q1.pl').

% Helper: A known candidate solution satisfying clues 1 through 9
% (Corresponds to Solution 2: Alex=(design, java, embedded), Carla=(testing, python, AI), etc.)
sample_sol_valid([
    p('Alex',  design,      java,       embedded),
    p('Ben',   development, javascript, web),
    p('Carla', testing,     python,     'AI'),
    p('Dana',  research,    'c++',      data)
]).

% Helper: A candidate solution designed to violate multiple clues
sample_sol_invalid([
    p('Alex',  development, 'c++',      'AI'),
    p('Ben',   testing,     java,       data),
    p('Carla', research,    python,     embedded),
    p('Dana',  design,      javascript, web)
]).

% Test 1: Candidate generator produces a 4-element list
test(valid_solution_structure) :-
    valid_solution(Sol),
    length(Sol, 4),
    !.

% Test 2: Clue 1 (AI not in research, not Dana)
test(clue_1) :-
    sample_sol_valid(Valid),
    clue(1, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(1, Invalid).

% Test 3: Clue 2 (Alex not development, not C++)
test(clue_2) :-
    sample_sol_valid(Valid),
    clue(2, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(2, Invalid).

% Test 4: Clue 3 (Testing likes Python)
test(clue_3) :-
    sample_sol_valid(Valid),
    clue(3, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(3, Invalid).

% Test 5: Clue 4 (Ben web, not testing)
test(clue_4) :-
    sample_sol_valid(Valid),
    clue(4, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(4, Invalid).

% Test 6: Clue 5 (Java works in design)
test(clue_5) :-
    sample_sol_valid(Valid),
    clue(5, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(5, Invalid).

% Test 7: Clue 6 (Carla not embedded, not development)
test(clue_6) :-
    sample_sol_valid(Valid),
    clue(6, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(6, Invalid).

% Test 8: Clue 7 (Dana not Java, research or testing)
test(clue_7) :-
    sample_sol_valid(Valid),
    clue(7, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(7, Invalid).

% Test 9: Clue 8 (Data in research, not JavaScript)
test(clue_8) :-
    sample_sol_valid(Valid),
    clue(8, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(8, Invalid).

% Test 10: Clue 9 (The friend who prefers AI works in testing)
test(clue_9) :-
    sample_sol_valid(Valid),
    clue(9, Valid),
    sample_sol_invalid(Invalid),
    \+ clue(9, Invalid).

% Test 11: count_solutions for empty active list gives all 13824 states
test(count_solutions_empty) :-
    count_solutions([], 13824).

% Test 12: count_solutions for clues 1 to 8 gives exactly 3 solutions
test(count_solutions_1_to_8) :-
    count_solutions([1,2,3,4,5,6,7,8], 3).

% Test 13: count_solutions for clues 1 to 9 gives unique solution (N = 1)
test(count_solutions_1_to_9_unique) :-
    count_solutions([1,2,3,4,5,6,7,8,9], 1).

% Runner predicate
run_test_case(Name) :-
    (   test(Name)
    ->  format('  [PASS] ~w~n', [Name])
    ;   format('  [FAIL] ~w~n', [Name]),
        fail
    ).

run_tests :-
    writeln('Running P1 Unit Tests:'),
    AllTests = [
        valid_solution_structure,
        clue_1, clue_2, clue_3, clue_4,
        clue_5, clue_6, clue_7, clue_8, clue_9,
        count_solutions_empty,
        count_solutions_1_to_8,
        count_solutions_1_to_9_unique
    ],
    forall(member(T, AllTests), run_test_case(T)),
    writeln('All P1 unit tests passed successfully!').
