---
name: scheme-dev
description: Development guide, conventions, strict built-in constraints, and quality checklist for Scheme/Racket solutions in CS F301 Assignment 2.
---

# Scheme / Racket Development Skill Guide (`scheme-dev`)

This skill defines the requirements, strict language subsets, coding conventions, execution protocols, and self-review checklists for developing Functional Programming solutions in Scheme/Racket for CS F301 Assignment 2 (Problems S1 and S2).

---

## 1. Environment & Language Target

- **Runtime Engine**: Racket 8.x
- **Language Directive**: Must start with `#lang racket/base` on line 1.
- **Execution Target**: Pure functional code adhering strictly to the minimal allowed primitive set.

### Allowed Built-in Primitives
Only the following built-ins from `#lang racket/base` may be used:
- **Binding & Functions**: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`
- **Conditionals & Control**: `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`
- **Data Construction & Inspection**: `quote` (written `'`), `cons`, `car`, `cdr`, `list`, `null?`, `pair?`, `eq?`, `assq`, `assoc`
- **Compositions of `car`/`cdr`**: Any combination up to 4 levels (e.g., `caar`, `cadr`, `cdar`, `cddr`, `caaar`, `caadr`, `cadar`, `caddr`, `cdaar`, `cdadr`, `cddar`, `cdddr`, `cadddr`, `cddddr`, etc.)
- **Arithmetic & Comparison**: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`
- **I/O**: `display`, `newline`
- **S2 Additional Allowed Built-in**: `read` (for reading from standard input in `print-insert-result`)

### Strictly Forbidden Built-ins & Constructs
- **State Mutation**: `set!`, `set-car!`, `set-cdr!`, or any mutating identifiers.
- **Data Structures**: No vectors (`vector`, `vector-ref`), no hash tables (`hash`, `make-hash`), no strings (`string`, `string-append`, `string-ref`).
- **Iteration / Loops**: No `do`, `for`, `for/list`, `for/fold`, `while`.
- **Standard Library List Utilities**:
  - FORBIDDEN: `length`, `append`, `reverse`, `map`, `filter`, `foldl`, `foldr`, `member`, `memq`, `memv`, `list-ref`, `list-tail`, `flatten`.
  - *Rule*: If you need any of these operations, you MUST write your own recursive helper (e.g., `my-length`, `my-map`, `my-reverse`, `my-append`).

---

## 2. Coding Conventions & Best Practices

### File Structure & Cleanliness
- The first line must be `#lang racket/base`.
- The file must contain **only definitions**.
- Do **not** call your functions at the top level and do **not** print anything when the file is loaded. The automated grader loads the file and invokes functions directly.

### Naming Conventions
- **Identifiers**: `kebab-case` (e.g., `print-inorder`, `insert-if-short`, `make-inserter`, `my-length`).
- **Predicates**: Must end with a question mark `?` (e.g., `empty-tree?`, `leaf?`, `len-ok?`).
- **Helpers**: Prefix custom implementations with `my-` or descriptive names (e.g., `my-map`, `my-length`, `tree-height`).

### Recursive Reading Comments
Every function must be preceded by a concise comment giving its **recursive reading** (explaining what it computes, its base case, and its recursive step):

```scheme
;; (insert-if-short x lst n)
;; Recursively checks each list level: if length < n, prefixes x.
;; Base case: empty list '() becomes (list x) if 0 < n, else '().
```

### Purity & Tail Recursion
- Pass all state through function arguments (accumulators).
- **Tail Recursion Requirement**: For list traversals and transformations on large inputs (tests include lists of 10,000 elements and nesting depth 100), helper functions must be tail-recursive with an accumulator where natural to prevent call stack overflow.
- Return proper lists, never improper/dotted pairs (ensure base cases terminate in `'()`).

---

## 3. How to Run and Test Code

### Command Line Invocations
- **Running a Scheme solution file**:
  ```bash
  racket id_q3.rkt
  racket id_q4.rkt
  ```
  *(Should produce no output when loaded cleanly without grader calls).*

- **Testing via REPL / Inline Racket Call**:
  ```bash
  racket -e '(enter! "id_q3.rkt") (print-inorder (quote (4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))))'
  ```
  ```bash
  racket -e '(enter! "id_q3.rkt") (print-all-traversals (quote (1 () (2 () (3 () ())))))'
  ```
  ```bash
  racket -e '(enter! "id_q3.rkt") (print-height-and-leaves (quote (a (b () ()) (c () ()))))'
  ```
- **Testing S2 Standard Input**:
  ```bash
  echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket -e '(enter! "id_q4.rkt") (print-insert-result)'
  ```
  Output must be exactly:
  `((42 1 2) (3 4 5) (42 6) (42))`

---

## 4. Known AI Failure Modes in Scheme

When generating Scheme/Racket code, AI tools frequently make the following mistakes:

1. **Hallucinating Forbidden Built-ins**:
   - Calling `(length lst)`, `(append l1 l2)`, `(reverse lst)`, or `(map f lst)`. These are strictly prohibited by the assignment constraints. Every utility must be self-implemented.
2. **Using String or Vector Conversions**:
   - Converting trees or lists to strings or vectors for manipulation. Only primitive lists and pairs are allowed.
3. **Accidental Mutation**:
   - Using `set!` or imperatively modifying state.
4. **Stack Overflow on Large Inputs (Non-Tail Recursion)**:
   - Writing naive recursions like `(+ 1 (my-length (cdr lst)))` which crash with out-of-memory or stack overflow on 10,000 elements. Accumulator-based tail recursion is required.
5. **Prompting on `read`**:
   - In `print-insert-result`, displaying prompt strings like `"Enter x: "`. The grader feeds raw data to standard input and matches stdout byte-for-byte; any prompt text causes immediate failure.
6. **Improper Dotted Pairs**:
   - Forgetting `'()` when rebuilding lists, producing `(1 . 2)` instead of `(1 2)`.
7. **Mutating the Length Metric During Traversal**:
   - In S2, inserting `x` into a list changes its length. The problem requires measuring the *original* length of the list before insertion.
8. **Top-Level Execution**:
   - Leaving test calls at the bottom of the file like `(print-inorder t1)`.

---

## 5. Pre-Response Self-Review Checklist

Before delivering or committing any Scheme solution, verify each item:

- [ ] **Decomposition Rule**: Is this code addressing only ONE unit of work (one function, one helper, or one test)?
- [ ] **Header Check**: Is line 1 `#lang racket/base`?
- [ ] **No Top-Level Calls**: Does `racket <file>` run silently with exit code 0 when invoked without arguments?
- [ ] **Strict Built-in Whitelist**:
  - [ ] Are `length`, `append`, `reverse`, `map`, `filter`, `flatten`, `member` absent?
  - [ ] Are all utilities custom written using only `cons`, `car`, `cdr`, `null?`, `pair?`, conditionals, and arithmetic?
- [ ] **No Mutation**: Are `set!`, `vector`, `hash`, and loops absent?
- [ ] **Output Exactness**:
  - S1: Does each function print with `display` and terminate with a `newline`?
  - S2: Does `print-insert-result` read `x`, `lst`, `n` in order and print ONLY the resulting list with `display` and `newline` (no prompt text)?
- [ ] **Higher-Order Requirement**: Is `insert-if-short` implemented via `make-inserter`?
- [ ] **Edge Cases**:
  - Empty tree `()` -> `print-inorder` prints `()`, `print-height-and-leaves` prints `(0 0)`.
  - Empty list `()` with $n > 0$ -> becomes `(x)`.
  - Deeply nested structures (up to depth 100) and large lists (10,000 elements).
- [ ] **Recursive Reading**: Is a contract and recursive reading documented above each function?
