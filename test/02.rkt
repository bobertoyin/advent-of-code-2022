#lang racket/base

(require rackunit
         "../advent/02.rkt")

(check-equal? (evaluate-interactions score-by-outcome TEST-FILE) 15 "part one sample test")

(check-equal? (evaluate-interactions score-by-expectation TEST-FILE) 12 "part two sample test")
