# Problem 1 Report: Department Assignment Puzzle Analysis

## 1. Solution Count for Clues 1 to 8 (Task P1.b)

Querying `count_solutions([1,2,3,4,5,6,7,8], N)` yields:
$$\mathbf{N = 3}$$

### What this reveals about the puzzle:
1. **Under-constrained specification**: Clues 1 through 8 narrow down the initial search space of $4! \times 4! \times 4! = 13,824$ assignments to exactly 3 candidate solutions. The clues given are necessary but insufficient on their own to determine a single, unique outcome.
2. **Fixed vs. Permutable Assignments**:
   - In all 3 solutions, **Ben** is deterministically assigned to `(development, javascript, web)`.
   - Across the remaining three friends (Alex, Carla, Dana), the department-language-project tuples exhibit ambiguity:
     - **Solution 1:**
       - Alex = [design, java, 'AI']
       - Ben = [development, javascript, web]
       - Carla = [research, 'c++', data]
       - Dana = [testing, python, embedded]
     - **Solution 2:**
       - Alex = [design, java, embedded]
       - Ben = [development, javascript, web]
       - Carla = [testing, python, 'AI']
       - Dana = [research, 'c++', data]
     - **Solution 3:**
       - Alex = [testing, python, embedded]
       - Ben = [development, javascript, web]
       - Carla = [design, java, 'AI']
       - Dana = [research, 'c++', data]

3. **Symmetry between Solution 1 and Solution 3**:
   - Solution 1 and Solution 3 share the **exact same set of four attribute tuples**:
     `{(design, java, 'AI'), (development, javascript, web), (research, 'c++', data), (testing, python, embedded)}`.
   - They differ only by which specific person receives which tuple (Alex and Carla swap `design/java/AI` and `testing/python/embedded`).

---

## 2. Puzzle Repair with Clue 9 (Task P1.c)

### Formulation of Clue 9
The assignment requires that Clue 9:
- Must **not** mention any friend by name.
- May refer only through attribute values (as in Clue 5).
- Must be true in the solution kept and false in every other solution of clues 1 to 8.

Because Solution 1 and Solution 3 have identical attribute pairings, **any attribute-only clue that holds for Solution 1 will also hold for Solution 3**, leading to $N \ge 2$. Therefore, the unique solution that can be isolated using an attribute-only rule is **Solution 2**.

In Solution 2, the AI project is paired with the testing department (under Carla), whereas in Solutions 1 and 3, the AI project is in design (paired with Java).

### Clue 9 Definition:
```text
% CLUE 9: The friend who prefers the AI project works in the testing department.
```

### Prolog Implementation:
```prolog
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Solution) :-
    member(p(_, testing, _, 'AI'), Solution).
```

### Verification:
- For Solution 1: testing is paired with embedded $\to$ **False**
- For Solution 2: testing is paired with 'AI' $\to$ **True**
- For Solution 3: testing is paired with embedded $\to$ **False**

Querying `count_solutions([1,2,3,4,5,6,7,8,9], N)` yields:
$$\mathbf{N = 1}$$

The unique remaining solution is:
- **Alex** = `[design, java, embedded]`
- **Ben** = `[development, javascript, web]`
- **Carla** = `[testing, python, 'AI']`
- **Dana** = `[research, 'c++', data]`
