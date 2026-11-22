#lang racket/base

;; (my-length lst)
;; Number of top-level elements of lst.
;; Recursive reading: carry a running count in acc; at each step drop the head
;; and add 1. Base case: empty lst -> acc holds the count. Tail recursive, so it
;; is safe on lists of 10,000 elements.
(define (my-length lst)
  (my-length-acc lst 0))

(define (my-length-acc lst acc)
  (if (null? lst)
      acc
      (my-length-acc (cdr lst) (+ acc 1))))
