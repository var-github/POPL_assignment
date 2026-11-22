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
