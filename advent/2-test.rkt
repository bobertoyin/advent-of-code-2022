#lang racket/base

(require rackunit
         "2.rkt")

(check-equal? (foldl + 0 (score-interactions TEST-FILE)) 15 "part one sample test")

(check-equal? (foldl + 0 (score-expectations TEST-FILE)) 12 "part two sample test")
