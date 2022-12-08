#lang racket/base

(require (only-in racket file->lines string->list first rest range flatten)
         racket/set)

(define FILE "input/8.txt")
(define TEST-FILE "input/8-test.txt")

;; MAIN
(module+ main
  (define lines (file->lines FILE))
  (define rows (map (lambda (idx-ln) (row->posns (cdr idx-ln) (car idx-ln))) (add-indices lines)))
  (define columns (rows->columns rows))
  (define score-table (build-score-table (make-immutable-hash) rows))
  (set-count (visible-trees rows columns))
  (apply max (hash-values (score-lines (score-lines score-table rows) columns))))

;; PART ONE

(struct tree (posn height) #:transparent)
(struct posn (x y) #:transparent)

(define (visible-trees rows columns)
  (set-union (foldl set-union (set) (map visible-line rows))
             (foldl set-union (set) (map visible-line columns))))

(define (visible-line tree-line)
  (set-union (list->set (flatten (visible-line-helper tree-line -1)))
             (list->set (flatten (visible-line-helper (reverse tree-line) -1)))))

(define (visible-line-helper tree-line max-height)
  (cond
    [(null? tree-line) '()]
    [else
     (define first-tree (first tree-line))
     (define rest-trees (rest tree-line))
     (if (> (tree-height first-tree) max-height)
         (cons first-tree (visible-line-helper rest-trees (max (tree-height first-tree) max-height)))
         (visible-line-helper rest-trees (max (tree-height first-tree) max-height)))]))

(define (rows->columns rows)
  (if (foldl (lambda (one two) (and one two)) #t (map null? rows))
      '()
      (cons (map first rows) (rows->columns (map rest rows)))))

(define (row->posns row row-index)
  (define columns (map string->number (map string (string->list row))))
  (define columns-indices (add-indices columns))
  (map (lambda (height-index) (tree (posn (car height-index) row-index) (cdr height-index)))
       columns-indices))

(define (add-indices lst)
  (map cons (range (length lst)) lst))

;; PART TWO

(define (score-lines table lines)
  (foldl score-line (foldl score-line table lines) (map (lambda (line) (reverse line)) lines)))

(define (score-line tree-line table)
  (score-line-helper table tree-line '()))

(define (score-line-helper table tree-line last-trees)
  (cond
    [(null? tree-line) table]
    [else
     (define first-tree (first tree-line))
     (define rest-trees (rest tree-line))
     (define score (score-single first-tree last-trees))
     (score-line-helper (update-table table first-tree score)
                        rest-trees
                        (cons first-tree last-trees))]))

(define (update-table table tree score)
  (hash-update table tree (lambda (curr-score) (* curr-score score))))

(define (score-single tree last-trees)
  (if (null? last-trees)
      0
      (if (> (tree-height tree) (tree-height (car last-trees)))
          (+ 1 (score-single tree (cdr last-trees)))
          1)))

(define (build-score-table table rows)
  (foldl build-score-table-helper table (flatten rows)))

(define (build-score-table-helper tree table)
  (hash-set table tree 1))
