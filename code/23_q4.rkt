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

;; (my-map f lst)
;; Applies f to each top-level element of lst, returning the list of results in
;; order. Recursive reading: the result is f of the head consed before my-map of
;; f over the tail. Base case: empty lst -> ().
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

;; (insert-if-short x lst n)
;; Inserts x at the front of every list, at every level of nesting, whose length
;; (measured on the original list, before any insertion) is less than n.
;; Defined with make-inserter: the predicate "length < n" is passed as len-ok?.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (k) (< k n))) lst))

;; (make-inserter x len-ok?)
;; Returns a function of one argument (a list) that inserts x at the front of
;; every list, at every level of nesting, whose original length satisfies the
;; predicate len-ok? (a function of one number). Atoms are left unchanged.
;; Recursive reading: same shape as insert-if-short, but the decision to prepend
;; x is made by calling len-ok? on the list's original length.
(define (make-inserter x len-ok?)
  (define (transform item)
    (if (or (null? item) (pair? item))
        (process item)
        item))
  (define (process l)
    (let ((mapped (my-map transform l)))
      (if (len-ok? (my-length l))
          (cons x mapped)
          mapped)))
  process)
