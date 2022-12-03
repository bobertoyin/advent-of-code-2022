#lang racket/base

(require (only-in racket file->lines index-of)
         racket/set)

(define FILE "input/3.txt")
(provide TEST-FILE)
(define TEST-FILE "input/3-test.txt")

;;MAIN
(module+ main
  (sum-priorities (map priorities (map shared-items (map rucksack (file->lines FILE)))))
  (sum-priorities (map priorities (map badge (make-groups (map string->set (file->lines FILE)) 3)))))

;; PART ONE

(define COMPONENTS (string->list "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(define (sum-priorities priority-sets)
  (foldl + 0 (map sum-priorities-helper priority-sets)))

(define (sum-priorities-helper priorities)
  (foldl + 0 priorities))

(define (priorities items)
  (map priority (set->list items)))

(define (priority item)
  (+ (index-of COMPONENTS item) 1))

(define (shared-items rucksack)
  (set-intersect (car rucksack) (cdr rucksack)))

(define (rucksack input)
  (cons (first-compartment input) (second-compartment input)))

(define (first-compartment input)
  (string->set (substring input 0 (/ (string-length input) 2))))

(define (second-compartment input)
  (string->set (substring input (/ (string-length input) 2))))

(define (string->set s)
  (list->set (string->list s)))

;; PART TWO

(define (badge group)
  (foldl set-intersect (list->set COMPONENTS) group))

(define (make-groups rucksacks size)
  (reverse (map reverse (make-groups-helper rucksacks size '() '()))))

(define (make-groups-helper rucksacks size current-group all-groups)
  (cond
    [(null? rucksacks)
     (cond
       [(null? current-group) all-groups]
       [else (cons current-group all-groups)])]
    [else
     (cond
       [(= (length current-group) size)
        (make-groups-helper rucksacks size '() (cons current-group all-groups))]
       [else
        (make-groups-helper (cdr rucksacks) size (cons (car rucksacks) current-group) all-groups)])]))
