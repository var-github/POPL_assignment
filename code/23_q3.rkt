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

;; (inorder-values tree)
;; Returns the list of node values of a binary tree in inorder
;; (left subtree, node, right subtree). Empty tree () yields ().
;; Recursive reading: inorder-acc tree acc = values of tree, inorder, followed
;; by acc. For a node it is: values of left, then the node value consed before
;; the values of right followed by acc. Using acc avoids append.
(define (inorder-values tree)
  (inorder-acc tree '()))

(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) acc)))))
