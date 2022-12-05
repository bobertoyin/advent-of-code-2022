#lang racket/base

(require (only-in racket
                  file->lines
                  string-split
                  string-trim
                  first
                  second
                  third
                  rest
                  take
                  drop
                  take-right
                  drop-right))

(define FILE "input/5.txt")
(define TEST-FILE "input/5-test.txt")

;; MAIN
(module+ main
  (define lines (file->lines FILE))
  (define 9000-stacks (make-hash))
  (define 9001-stacks (make-hash))
  (define unsetup-stack (data->stack-setup lines))
  (define commands (modify-lines->commands lines))
  (stack-setup->stacks 9000-stacks unsetup-stack)
  (stack-setup->stacks 9001-stacks unsetup-stack)
  (crane-9000 9000-stacks commands)
  (crane-9001 9001-stacks commands)
  9000-stacks
  9001-stacks)

;; PART ONE

(define STACK-SET-REGEX #rx"[A-Z]")
(define STACK-MODIFY-REGEX #rx"move [0-9]+ from [0-9]+ to [0-9]+")

(define (crane-9000 stacks commands)
  (map (lambda (command) (execute-command stacks command reverse)) commands))

(define (execute-command stacks command modify-stack)
  (define amount (first command))
  (define sender (second command))
  (define receiver (third command))
  (define index (- (length (hash-ref stacks sender)) amount 1))
  (cond
    [(>= -1 index)
     (define move (modify-stack (take (hash-ref stacks sender) amount)))
     (hash-update! stacks receiver (lambda (stack) (append stack move)))
     (hash-update! stacks sender (lambda (stack) (drop stack amount)))]
    [else
     (define move (modify-stack (take-right (hash-ref stacks sender) amount)))
     (hash-update! stacks receiver (lambda (stack) (append stack move)))
     (hash-update! stacks sender (lambda (stack) (drop-right stack amount)))]))

(define (modify-lines->commands lines)
  (map (lambda (command) (map string->number (regexp-match* #rx"[0-9]+" command)))
       (filter modifies-stack? lines)))

(define (stack-setup->stacks stacks setup)
  (map (lambda (row) (map (lambda (entry) (update-stacks stacks entry)) row)) (reverse setup)))

(define (data->stack-setup data)
  (map (lambda (row) (map position-item->stack-item row))
       (lines->stack-setup (filter defines-stack? data))))

(define (update-stacks stacks entry)
  (cond
    [(hash-has-key? stacks (car entry))
     (hash-update! stacks (car entry) (lambda (stack) (append stack (list (cdr entry)))))]
    [else (hash-set! stacks (car entry) (list (cdr entry)))]))

(define (position-item->stack-item item)
  (cons (index->stack-num (car (car item))) (cdr item)))

(define (lines->stack-setup lines)
  (map (lambda (pair) (zip (car pair) (cdr pair)))
       (zip (map define-stack->positions lines) (map define-stack->values lines))))

(define (define-stack->positions line)
  (regexp-match-positions* STACK-SET-REGEX line))

(define (define-stack->values line)
  (regexp-match* STACK-SET-REGEX line))

(define (zip one two)
  (cond
    [(null? one) two]
    [(null? two) one]
    [else (append (list (cons (first one) (first two))) (zip (rest one) (rest two)))]))

(define (index->stack-num index)
  (+ (/ (- index 1) 4) 1))

(define (modifies-stack? line)
  (regexp-match? STACK-MODIFY-REGEX line))

(define (defines-stack? line)
  (regexp-match? STACK-SET-REGEX line))

;; PART TWO

(define (crane-9001 stacks commands)
  (map (lambda (command) (execute-command stacks command (lambda (move) move))) commands))
