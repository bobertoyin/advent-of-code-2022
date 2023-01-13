#lang racket/base

(require (only-in racket file->lines take))

(define FILE "input/01.txt")
(provide TEST-FILE)
(define TEST-FILE "input/01-test.txt")

(module+ main
  (most-calories-n-sum FILE 1)
  (most-calories-n-sum FILE 3))

#| Return the sum of the top n elves carrying the most calories.

Takes the input text file representing the list of calorie counts.

Path-string -> Number

Example: "input/file.txt" -> 3000
|#
(provide most-calories-n-sum)
(define (most-calories-n-sum file n)
  (foldr + 0 (take (sorted-calorie-record file) n)))

#| Create a sorted record of calorie counts in descending order.

Takes the input text file representing the list of calorie counts.

Path-string -> List[Number]

Example: "data/file.txt" -> [5000, 4500, 12, 0]
|#
(define (sorted-calorie-record file_path)
  (sort (calorie-list->calorie-record (map string->number (file->lines file_path)) (list 0)) >))

#| Convert a list of calorie counts into a record of calorie counts.

A "list" of calorie counts are the unaggregated counts of calories that are held by elves,
delimited between each elf by a #f. The record is the aggregated counts, such that each
count represents the total calories for a single elf. Requires an initial record with at least
one element inside it.

The list of calorie counts is processed left to right, but the record is built right to left.

List[Union[Number, False]], List[Number] -> List[Number]

Example: [1000, 2000, #f, 12], [0] -> [12, 3000]
Example: [1000, 2000, #f, 12, #f], [1000, 1000] -> [0, 12, 4000, 1000]
|#
(define (calorie-list->calorie-record lst record)
  (cond
    [(null? lst) record]
    [else (calorie-list->calorie-record (cdr lst) (add-calorie (car lst) record))]))

#| Add a single calorie count to a record of calorie counts.

There must be at least one calorie count in the record to start.
A calorie count of #f indicates that a new count must be appended to the record.
The record is built right to left.

Union[Number, False], List[Number] -> List[Number]

Example: 1000, [2000, 1000] -> [3000, 1000]
Example: #f, [2000, 1000] -> [0, 2000, 1000]
|#
(define (add-calorie calorie calorie-records)
  (cond
    [(not calorie) (cons 0 calorie-records)]
    [else (cons (+ calorie (car calorie-records)) (cdr calorie-records))]))
