#lang racket/base

(require rackunit
         "../advent/1.rkt")

(check-equal? (part-one TEST-FILE) 24000 "part one sample test")

(check-equal? (part-two TEST-FILE) 45000 "part two sample test")
