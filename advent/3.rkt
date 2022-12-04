#lang racket/base

(require (only-in racket file->lines index-of)
         racket/set)

(define FILE "input/3.txt")
(provide TEST-FILE)
(define TEST-FILE "input/3-test.txt")

;; MAIN
(module+ main
  (part-one FILE)
  (part-two FILE))

;; PART ONE

;; Component list, such that the priority value of the component is its index + 1.
(define COMPONENTS (string->list "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(provide part-one)
(define (part-one FILE-PATH)
  (sum-priorities (map (lambda (rucksack) (set-intersect (car rucksack) (cdr rucksack)))
                       (map rucksack (file->lines FILE-PATH)))))

;; Summation of the priority values for a list of set of components.
;; List[Set[Char]] -> Number
;; Example: [{"b", "c"], {"a"}, {}] -> 6
(define (sum-priorities item-sets)
  (foldl + 0 (map (lambda (priorities) (foldl + 0 priorities)) (map priorities item-sets))))

;; Summation of the priority values for a set of components.
;; Set[Char] -> Number
;; Example: {"a", "b", "c"} -> 6
(define (priorities items)
  (map (lambda (item) (+ (index-of COMPONENTS item) 1)) (set->list items)))

;; Convert a line of input into its rucksack representation.
;; String -> Cons[Set[Char], Set[Char]]
;; Example: "abcdefgh" -> [{"a", "b", "c", "d"}, {"e", "f", "g", "h"}]
(define (rucksack input)
  (cons (first-compartment input) (second-compartment input)))

;; Convert a line of input into the first compartment of a rucksack.
;; String -> Set[Char]
;; Example: "abcdefgh" -> {"a", "b", "c", "d"}
(define (first-compartment input)
  (string->set (substring input 0 (/ (string-length input) 2))))

;; Convert a line of input into the second compartment of a rucksack.
;; String -> Set[Char]
;; Example: "abcdefgh" -> {"e", "f", "g", "h"}
(define (second-compartment input)
  (string->set (substring input (/ (string-length input) 2))))

;; Convert a string into a set of its characters.
;; String -> Set[Char]
;; Example: "abcdefgh" -> {"a", "b", "c", "d", "e", "f", "g", "h"}
(define (string->set s)
  (list->set (string->list s)))

;; PART TWO

(provide part-two)
(define (part-two FILE-PATH)
  (sum-priorities (map badge (make-groups (map string->set (file->lines FILE-PATH)) 3))))

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
