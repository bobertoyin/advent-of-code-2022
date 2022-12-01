#lang racket

(require rackunit "1.rkt")

(check-equal? 
    (first (sorted-elf-intake TEST_FILE))
    24000
    "part one sample test"
)

(check-equal?
    (first-n-sum 3 (sorted-elf-intake TEST_FILE))
    45000
    "part two sample test"
)
