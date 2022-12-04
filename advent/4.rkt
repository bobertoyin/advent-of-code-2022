#lang racket/base

(require (only-in racket file->lines string-split first last))

(define FILE "input/4.txt")
(provide TEST-FILE)
(define TEST-FILE "input/4-test.txt")

;; MAIN
(module+ main
  (define PARSED (map parse-line (file->lines FILE)))
  (filter-length full-containment PARSED)
  (filter-length partial-containment PARSED))

;; PART ONE

(define (filter-length func input)
  (length (filter (lambda (line) (func (first line) (last line))) input)))

(define (parse-line line)
  (map (lambda (n) (map string->number (string-split n "-"))) (string-split line ",")))

(define (full-containment one two)
  (or (and (<= (first one) (first two)) (>= (last one) (last two)))
      (and (>= (first one) (first two)) (<= (last one) (last two)))))

;; PART TWO

(define (partial-containment one two)
  (and (>= (last one) (first two)) (<= (first one) (last two))))
