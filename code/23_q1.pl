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

% Clue 5: The friend whose favorite language is Java works in the design department.
clue(5, Solution) :-
    member(p(_, design, java, _), Solution).

% Clue 6: Carla's project preference is not embedded, and her department is not development.
clue(6, Solution) :-
    member(p('Carla', Dept, _, Proj), Solution),
    Proj \= embedded,
    Dept \= development.

% Clue 7: Dana's favorite language is not Java, and she works in research or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

% Clue 8: The friend who prefers data projects works in research and does not use JavaScript.
clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.
