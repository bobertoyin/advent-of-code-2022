#lang racket/base

(require (only-in racket file->lines string-split first last))

(define FILE "input/4.txt")
(provide TEST-FILE)
(define TEST-FILE "input/4-test.txt")

;; MAIN
(module+ main
  (part-one FILE)
  (part-two FILE))

;; PART ONE

(provide part-one)
(define (part-one FILE-PATH)
  (filter-length full-containment (map parse-line (file->lines FILE-PATH))))

(define (filter-length func input)
  (length (filter (lambda (line) (func (first line) (last line))) input)))

(define (parse-line line)
  (map (lambda (n) (map string->number (string-split n "-"))) (string-split line ",")))

(define (full-containment one two)
  (or (and (<= (first one) (first two)) (>= (last one) (last two)))
      (and (>= (first one) (first two)) (<= (last one) (last two)))))

;; PART TWO

(provide part-two)
(define (part-two FILE-PATH)
  (filter-length partial-containment (map parse-line (file->lines FILE-PATH))))

(define (partial-containment one two)
  (and (>= (last one) (first two)) (<= (first one) (last two))))
