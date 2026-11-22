#lang racket/base

;; Tests for S2 (code/23_q4.rkt). Covers the assignment examples, deep nesting
;; (depth 100) and a large list (10,000 elements). Run with:
;;   racket tests/test_q4.rkt
;;
;; The solution exports nothing, so this harness reads its forms into a fresh
;; base namespace. A reference implementation (built with the normal length/map,
;; which the solution may not use) is used to cross-check the general behaviour.

(require racket/runtime-path racket/port)

(define-runtime-path solution-path "../code/23_q4.rkt")
(define ns (make-base-namespace))

(define (load-solution path)
  (define in (open-input-file path))
  (read-line in)                      ; skip "#lang racket/base"
  (parameterize ([current-namespace ns])
    (let loop ()
      (define form (read in))
      (unless (eof-object? form) (eval form) (loop))))
  (close-input-port in))
(load-solution solution-path)

;; Call the solution's insert-if-short inside its namespace.
(define (ii x lst n)
  (parameterize ([current-namespace ns])
    (eval (list 'insert-if-short (list 'quote x) (list 'quote lst) n))))

;; Call the solution's print-insert-result with a given input string; return output.
(define (run-print input-string)
  (parameterize ([current-namespace ns])
    (with-output-to-string
      (lambda ()
        (parameterize ([current-input-port (open-input-string input-string)])
          (eval '(print-insert-result)))))))

;; Reference implementation using the ordinary built-ins (allowed in tests only).
(define (ref x lst n)
  (define (tf item) (if (list? item) (proc item) item))
  (define (proc l)
    (let ((m (map tf l)))
      (if (< (length l) n) (cons x m) m)))
  (proc lst))

(define pass 0)
(define fail 0)
(define (check label got expected)
  (cond
    ((equal? got expected)
     (set! pass (+ pass 1)) (display "  [PASS] ") (display label) (newline))
    (else
     (set! fail (+ fail 1)) (display "  [FAIL] ") (display label) (newline)
     (display "    expected: ") (write expected) (newline)
     (display "    got:      ") (write got) (newline))))

(display "Running S2 (q4) tests:") (newline)

;; --- Assignment examples (insert-if-short) ---
(check "ex1" (ii 42 '((1 2) (3 4 5) (6) ()) 3) '((42 1 2) (3 4 5) (42 6) (42)))
(check "ex2" (ii 0 '(((1) 2) (3) ((4 5 6) ())) 3) '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))
(check "ex3 (7 () 3)" (ii 7 '() 3) '(7))
(check "ex4 (7 () 0)" (ii 7 '() 0) '())

;; --- Assignment examples via print-insert-result (stdin -> stdout) ---
(check "print ex1" (run-print "42 ((1 2) (3 4 5) (6) ()) 3") "((42 1 2) (3 4 5) (42 6) (42))\n")
(check "print ex4" (run-print "7 () 0") "()\n")

;; --- Extra edge cases cross-checked against the reference ---
(check "n=0 leaves all lists (no insertion)" (ii 'x '((1) (2 3) ()) 0) (ref 'x '((1) (2 3) ()) 0))
(check "symbols as atoms" (ii 'q '(a (b c) (d)) 2) (ref 'q '(a (b c) (d)) 2))

;; --- Deep nesting, depth 100 ---
(define (nest d) (if (= d 0) '(1) (list (nest (- d 1)))))
(define deep (nest 100))
(check "deep nesting depth 100 matches reference" (ii 'z deep 2) (ref 'z deep 2))

;; --- Large list, 10,000 elements ---
(define (build n acc) (if (= n 0) acc (build (- n 1) (cons n acc))))
(define big (build 10000 '()))
;; top length 10000; with n=10001 the top list gets z prepended -> length 10001
(define big-out (ii 'z big 10001))
(check "big list length after insert" (length big-out) 10001)
(check "big list head is inserted x" (car big-out) 'z)
(check "big list matches reference" big-out (ref 'z big 10001))

(newline)
(display pass) (display " passed, ") (display fail) (display " failed") (newline)
