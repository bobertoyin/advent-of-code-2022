#lang racket/base

(require (only-in racket first)
         rackunit
         "1.rkt")

(check-equal? (first (sorted-elf-intake TEST-FILE)) 24000 "part one sample test")

(check-equal? (first-n-sum 3 (sorted-elf-intake TEST-FILE)) 45000 "part two sample test")
