#lang racket/base

(require (only-in racket file->lines))

(define FILE "input/11.txt")
(define TEST-FILE "input/11-test.txt")

;; MAIN
(module+ main
  (define TEST-MONKEY-0
    (monkey 0 (list 79 98) (lambda (x) (* x 19)) (lambda (x) (if (= (modulo x 23) 0) 2 3))))
  (define TEST-MONKEY-1
    (monkey 1 (list 54 65 75 74) (lambda (x) (+ x 6)) (lambda (x) (if (= (modulo x 19) 0) 2 0))))
  (define TEST-MONKEY-2
    (monkey 2 (list 79 60 97) (lambda (x) (* x x)) (lambda (x) (if (= (modulo x 13) 0) 1 3))))
  (define TEST-MONKEY-3
    (monkey 3 (list 74) (lambda (x) (+ x 3)) (lambda (x) (if (= (modulo x 17) 0) 0 1))))
  (define TEST-MONKEYS
    (foldl build-monkey-table (hash) (list TEST-MONKEY-0 TEST-MONKEY-1 TEST-MONKEY-2 TEST-MONKEY-3)))
  (run-round TEST-MONKEYS))

;; PART ONE

(struct monkey (number items op test) #:transparent)

(define (run-round table)
    (hash-values table #t)
)

(define (throw-to item op test)
    (test (floor (/ (op item) 3)))
)

(define (build-monkey-table monkey table)
  (hash-set table (monkey-number monkey) monkey))
