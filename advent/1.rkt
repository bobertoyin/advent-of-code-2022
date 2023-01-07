#lang racket/base

(require (only-in racket file->lines))

(define FILE "input/1.txt")
(provide TEST-FILE)
(define TEST-FILE "input/1-test.txt")

;; MAIN
(module+ main
  (part-one FILE)
  (part-two FILE))

;; PART ONE

(provide part-one)
(define (part-one file) (car (sorted-elf-intake file)))

;; Return the caloric intake of all elves given a file path for text inputs.
;; Output is sorted from highest to lowest caloric intake.
;; Path-string -> List[Number]
;; Example: "data/file.txt" -> [5000, 4500, 12, 0]
(define (sorted-elf-intake file_path)
  (sort (foods-to-elves (map string->number (file->lines file_path)) (list 0)) >))

;; Add foods (calories) for the list of elves. There must be at least one elf to start.
;; A food of #f is a delimiter between elf records.
;; The food list is consumed left to right, but the elf list is built right to left.
;; List[Union[Number, False]], List[Number] -> List[Number]
;; Example: [1000, 2000, #f, 12], [0] -> [12, 3000]
;; Example: [1000, 2000, #f, 12, #f], [1000, 1000] -> [0, 12, 4000, 1000]
(define (foods-to-elves foods elves)
  (cond
    [(null? foods) elves]
    [else (foods-to-elves (cdr foods) (add-food (car foods) elves))]))

;; Add a single food (calorie count) for the list of elves. There must be at least one elf to start.
;; A food of #f indicates that a new elf record must be made.
;; The elf list is build right to left.
;; Union[Number, False], List[Number] -> List[Number]
;; Example: 1000, [2000, 1000] -> [3000, 1000]
;; Example: #f, [2000, 1000] -> [0, 2000, 1000]
(define (add-food food elves)
  (cond
    [(not food) (cons 0 elves)]
    [else (cons (+ food (car elves)) (cdr elves))]))

;; PART TWO

(provide part-two)
(define (part-two file) (first-n-sum 3 (sorted-elf-intake file)))

;; Return the sum of the first n values of a list.
;; Assumes that the list is non-empty.
;; Integer, List[Number] -> Number
;; Example: 3, [1, 2, 3, 4] -> 6
(define (first-n-sum n values)
  (cond
    [(= n 1) (car values)]
    [else (+ (car values) (first-n-sum (- n 1) (cdr values)))]))
