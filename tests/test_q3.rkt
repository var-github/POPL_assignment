#lang racket/base

;; Tests for S1 (code/23_q3.rkt), using the example trees from the assignment.
;; Run from anywhere with:  racket tests/test_q3.rkt
;;
;; The solution file is "#lang racket/base" and exports nothing, so this harness
;; reads its forms and evaluates them into a fresh base namespace, then captures
;; what each print- function writes and compares it to the expected text.

(require racket/runtime-path racket/port)

(define-runtime-path solution-path "../code/23_q3.rkt")

(define ns (make-base-namespace))

(define (load-solution path)
  (define in (open-input-file path))
  (read-line in)                      ; skip the "#lang racket/base" line
  (parameterize ([current-namespace ns])
    (let loop ()
      (define form (read in))
      (unless (eof-object? form)
        (eval form)
        (loop))))
  (close-input-port in))

(load-solution solution-path)

;; (run fn-name tree) -> the string the solution prints for (fn-name tree)
(define (run fn-name tree)
  (with-output-to-string
    (lambda ()
      (parameterize ([current-namespace ns])
        (eval (list fn-name (list 'quote tree)))))))

(define pass 0)
(define fail 0)

(define (check label got expected)
  (cond
    ((equal? got expected)
     (set! pass (+ pass 1))
     (display "  [PASS] ") (display label) (newline))
    (else
     (set! fail (+ fail 1))
     (display "  [FAIL] ") (display label) (newline)
     (display "    expected: ") (write expected) (newline)
     (display "    got:      ") (write got) (newline))))

;; Example trees from the assignment
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define empty '())

(display "Running S1 (q3) tests:") (newline)

;; print-inorder
(check "t1 print-inorder"    (run 'print-inorder t1)    "(1 2 3 4 5 6 7)\n")
(check "empty print-inorder" (run 'print-inorder empty) "()\n")

;; print-all-traversals
(check "t1 print-all-traversals"
       (run 'print-all-traversals t1)
       "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check "t2 print-all-traversals"
       (run 'print-all-traversals t2)
       "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check "t3 print-all-traversals"
       (run 'print-all-traversals t3)
       "(b a c)\n(a b c)\n(b c a)\n")
(check "empty print-all-traversals"
       (run 'print-all-traversals empty)
       "()\n()\n()\n")

;; print-height-and-leaves
(check "t1 print-height-and-leaves"    (run 'print-height-and-leaves t1)    "(3 4)\n")
(check "t2 print-height-and-leaves"    (run 'print-height-and-leaves t2)    "(3 1)\n")
(check "t3 print-height-and-leaves"    (run 'print-height-and-leaves t3)    "(2 2)\n")
(check "empty print-height-and-leaves" (run 'print-height-and-leaves empty) "(0 0)\n")

(newline)
(display pass) (display " passed, ") (display fail) (display " failed") (newline)
