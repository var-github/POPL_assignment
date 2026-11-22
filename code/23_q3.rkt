#lang racket/base

;; (my-reverse lst)
;; Reverses a proper list using an accumulator.
;; Recursive reading: carry the reversed prefix in acc; at each step move the
;; head of lst onto acc. Base case: empty lst -> acc holds the full reversal.
;; Tail recursive, so it is safe on long lists.
(define (my-reverse lst)
  (my-reverse-acc lst '()))

(define (my-reverse-acc lst acc)
  (if (null? lst)
      acc
      (my-reverse-acc (cdr lst) (cons (car lst) acc))))
