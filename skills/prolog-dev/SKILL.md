---
name: prolog-dev
description: Development guide, conventions, test workflows, and quality checklist for SWI-Prolog solutions in CS F301 Assignment 2.
---

# Prolog Development Skill Guide (`prolog-dev`)

This skill defines the requirements, conventions, execution protocols, and self-review checklists for developing Logic Programming solutions in SWI-Prolog for CS F301 Assignment 2 (Problems P1 and P2).

---

## 1. Environment & Target Version

- **Prolog Engine**: SWI-Prolog version 9.x (`swipl`)
- **Execution Target**: Standard compliant, portable SWI-Prolog code without GUI dependencies.

### Allowed Libraries
Only the following built-in modules are permitted:
- `library(lists)`
- `library(apply)`
- `library(yall)`
- `library(aggregate)`

### Forbidden Constructs
- No assert or related commands
- No retract or related commands
- No global variables
- String Parsing Evals: Do NOT build a string and parse it back into a term to evaluate it. Expressions must be evaluated structurally via predicate logic.
- Directives & Exits: Do NOT include `:- initialization(...)` directives. Do NOT call `halt/0` inside your solution files.

---

## 2. Coding Conventions & Best Practices

### File Structure & Cleanliness
- The file must contain **only definitions** (clauses, facts, rules, and optional module imports `:- use_module(library(...)).`).
- No interactive queries or top-level execution side-effects upon loading.

### Naming Conventions
- **Predicates**: `snake_case/Arity` (e.g., `clue/2`, `count_solutions/2`, `generate_equation/2`, `eval_expr/2`).
- **Variables**: CamelCase starting with an uppercase letter or underscore (e.g., `Solution`, `LeftExpr`, `Acc`).
- **Atoms**: Lowercase or single-quoted when containing special characters/spaces (e.g., `research`, `design`, `'c++'`, `'AI'`).

### Declarative Reading & Comments
Every predicate must be preceded by a concise comment giving its **declarative reading** (stating *what relationship* holds true, rather than step-by-step procedural instructions):

```prolog
% eval_expr(Expr, Val): Holds when Val is the integer result of evaluating Expr,
% where all divisions are exact with non-zero divisors.
```

---

## 3. How to Run and Test Code

### Command Line Invocations
- **Running `main/0` (P1 solve task)**:
  ```bash
  swipl -q -f id_q1.pl -g main -t halt
  ```
- **Running a specific goal / query**:
  ```bash
  swipl -q -f id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)" -t halt
  ```
  ```bash
  swipl -q -f id_q2.pl -g "generate_equation([4,2,5,3], E), writeln(E)" -t halt
  ```
  ```bash
  swipl -q -f id_q2.pl -g "all_equations([4,2,5,3], Es), writeln(Es)" -t halt
  ```

### Testing Guidelines
- Create standalone test files in `tests/` that load the solution file and execute test suites using `plunit` or simple verification goals.
- Test edge cases:
  - Empty lists `[]` or single-element lists `[X]` (must fail gracefully, never error or loop).
  - Division by zero and fractional division (must fail immediately).
  - Search order and determinism (`all_equations/2` sorted by `sort/2`, no duplicates).

---

## 4. Known AI Failure Modes in Prolog

When writing Prolog, AI tools routinely make the following errors. Be vigilant against:

1. **Left Recursion & Infinite Loops**:
   - Defining rules like `path(X, Y) :- path(X, Z), edge(Z, Y).` which loop infinitely. Base cases must come first, and recursion must be right-recursive or guard-bounded.
2. **Premature Evaluation / Unbound**:
   - In Prolog, `is/2` requires the right-hand side to be fully ground. Calling `X is Y + 1` before `Y` is bound raises an `instantiation_error`.
3. **Overusing or Misplacing Cuts (`!`)**:
   - Placing cuts aggressively can prune valid backtracking paths, causing queries to miss solutions or fail in multi-directional use.
4. **Impure Procedural Habits**:
   - Attempting to simulate loops or mutable accumulators with `assertz` or `nb_setval` instead of standard tail-recursive accumulator patterns.
5. **Inefficient Backtracking / Permutation Explosion**:
   - Testing clues by generating all $4! \times 4! \times 4! \times 4!$ states before testing constraints. Constraints must be interleaved with or directly applied to candidate generation.
6. **String Evaluation Cheat**:
   - Using string manipulation and `read_term_from_atom` to bypass AST evaluation. The rubric explicitly forbids this.
7. **Calling `halt/0` or Adding `:- initialization`**:
   - Terminating the SWI-Prolog session or printing on file load breaks the automated grading harness.

---

## 5. Pre-Response Self-Review Checklist

Before delivering or committing any Prolog solution, verify each item:

- [ ] **Decomposition Rule**: Is this code addressing only ONE unit of work (one predicate, one helper, or one test suite)?
- [ ] **Clean Loading**: Does `swipl -q -f <file> -t halt` load cleanly without printing anything to stdout?
- [ ] **Directive Check**: Are there zero `:- initialization(...)` lines and zero `halt/0` calls?
- [ ] **Purity & State**: Are `assert`, `retract`, and `setval` completely absent?
- [ ] **Library Restrictions**: Are only `lists`, `apply`, `yall`, and `aggregate` used?
- [ ] **Failure Behavior**: Does the predicate fail (`false`) rather than crash or loop infinitely when no solution exists?
- [ ] **Formatting Exactness**:
  - P1: Does `main/0` print exactly four lines formatted as `Name = [Dept, Lang, Project]`?
  - P2: Are canonical equations returned as SWI-Prolog strings with correct precedence/associativity parentheses, and no spaces?
- [ ] **Comments & Declarative Reading**: Does every predicate have a simple comment stating what relationship it defines?
