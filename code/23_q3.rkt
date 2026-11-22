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

;; (print-inorder tree)
;; Prints the inorder list of the tree's values on one line with display,
;; followed by a newline. The empty tree prints ().
(define (print-inorder tree)
  (display (inorder-values tree))
  (newline))

;; (preorder-values tree)
;; Returns the node values in preorder (node, left subtree, right subtree).
;; Recursive reading: preorder-acc tree acc = node value, then preorder of left,
;; then preorder of right, followed by acc. Empty tree yields acc.
(define (preorder-values tree)
  (preorder-acc tree '()))

(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc (cadr tree)
                          (preorder-acc (caddr tree) acc)))))

;; (postorder-values tree)
;; Returns the node values in postorder (left subtree, right subtree, node).
;; Recursive reading: postorder-acc tree acc = postorder of left, then postorder
;; of right, then the node value consed before acc. Empty tree yields acc.
(define (postorder-values tree)
  (postorder-acc tree '()))

(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree)
                                    (cons (car tree) acc)))))

;; (print-all-traversals tree)
;; Prints three lines with display: the inorder list, the preorder list and the
;; postorder list of the tree's values, each followed by a newline.
(define (print-all-traversals tree)
  (display (inorder-values tree))
  (newline)
  (display (preorder-values tree))
  (newline)
  (display (postorder-values tree))
  (newline))
