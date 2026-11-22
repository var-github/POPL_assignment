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

---

## 3. Independent Verification by Hand Deduction 

To cross-check the Prolog result, I solved clues 1 to 8 manually, without enumeration.

**Step 1: Ben.**
- Clue 4 gives Ben the web project and rules out testing.
- Clue 8 says the data-project friend works in research, so Ben (web) is not in research.
- Clues 2 and 6 rule out development for Alex and Carla, and clue 7 limits Dana to research or testing.
- So **Ben works in development**.
- Ben cannot like Python (clue 3 ties Python to testing) or Java (clue 5 ties Java to design), and Ben is not in research, where clue 8 bars JavaScript. That leaves **Ben ∈ {c++, javascript}**.

**Step 2: Branch on Dana (research or testing).**

*Case A: Dana is in testing.*
- Clue 3 gives Dana Python.
- Dana cannot have AI (clue 1), web (Ben's) or data (research's), so Dana gets **embedded**.
- Alex and Carla split research and design. Research gets data (clue 8) and design gets AI (clue 1).
- Java belongs to a design friend (clue 5), so the design friend has Java. The research friend cannot have JavaScript (clue 8), so research has C++ and Ben has JavaScript.
- Alex cannot like C++ (clue 2), so Alex is in design and Carla is in research.
- This gives **Solution 1**.

*Case B: Dana is in research.*
- Dana gets data (clue 8). Dana cannot have Java (clue 7), Python (testing's) or JavaScript (clue 8), so Dana has **C++** and Ben has JavaScript.
- Alex and Carla split testing (Python) and design (Java), and they hold AI and embedded between them.
- Carla cannot have embedded (clue 6), so Carla has AI and Alex has embedded.
- Clues 1 to 8 do not say who is in testing and who is in design, so both swaps are valid, giving **Solutions 2 and 3**.

**Conclusion:** exactly 3 solutions, matching `count_solutions([1,2,3,4,5,6,7,8], N)` giving `N = 3`. The only open question is whether Alex or Carla is in testing, and in Case A the other attributes force the assignment.

## 4. Other Valid Candidates for Clue 9

Any attribute-only clue that is true in Solution 2 and false in Solutions 1 and 3 would also repair the puzzle. Two other examples:

| Candidate clue | Sol. 1 | Sol. 2 | Sol. 3 |
|---|---|---|---|
| The friend who likes Python prefers the AI project | False | **True** | False |
| The friend who prefers the embedded project works in design | False | **True** | False |

Both are valid because they distinguish Solution 2, where AI pairs with Python and testing and embedded pairs with design. By contrast, no attribute-only clue can separate Solution 1 from Solution 3, since they contain identical tuples. Only a clue naming a friend could, and the assignment forbids that. This confirms that Solution 2 is the only target an attribute-only clue 9 can isolate.

## 5. Implementation Note

In `main/0` the comment says it solves for "clues 1 to 8", but the code calls `solve_active([1,2,3,4,5,6,7,8,9], ...)`. The code is correct, because the repaired puzzle uses all nine clues, but the comment should read "clues 1 to 9" so it matches the behaviour.
