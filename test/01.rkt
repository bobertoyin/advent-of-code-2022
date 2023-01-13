#lang racket/base

(require rackunit
         "../advent/01.rkt")

(check-equal? (most-calories-n-sum TEST-FILE 1) 24000 "part one sample test")

(check-equal? (most-calories-n-sum TEST-FILE 3) 45000 "part two sample test")
