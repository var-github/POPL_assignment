:- use_module(library(lists)).

% valid_solution(-Solution)
% True when Solution represents a complete candidate assignment for the four
% friends: 'Alex', 'Ben', 'Carla', and 'Dana' in fixed order.
% Each attribute (department, favorite language, and project) is a permutation
% of the allowed domain values, ensuring each value is used exactly once.
valid_solution([
    p('Alex', DeptA, LangA, ProjA),
    p('Ben',   DeptB, LangB, ProjB),
    p('Carla', DeptC, LangC, ProjC),
    p('Dana',  DeptD, LangD, ProjD)
]) :-
    permutation([research, development, design, testing], [DeptA, DeptB, DeptC, DeptD]),
    permutation([python, java, 'c++', javascript], [LangA, LangB, LangC, LangD]),
    permutation(['AI', web, embedded, data], [ProjA, ProjB, ProjC, ProjD]).

% clue(+N, +Solution)
% True when clue number N holds in a fully filled-in Solution.

% Clue 1: The friend who prefers the AI project does not work in research and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.
