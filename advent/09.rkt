#lang racket/base

(require (only-in racket file->lines string-split const take last)
         racket/set)

(define FILE "input/9.txt")
(define TEST-FILE "input/9-test.txt")

;; MAIN
(module+ main
  (define movements (foldl line->movements (list) (file->lines FILE)))
  (part-one (rope (posn 0 0) (posn 0 0)) movements)
  (part-two (init-long-rope 10) movements))

;; PART ONE
(struct visits (visited rope) #:transparent)
(struct rope (head tail) #:transparent)
(struct posn (x y) #:transparent)

(define (part-one start-rope movements)
  (set-count (visits-visited (foldl move-rope (visits (set) start-rope) movements))))

(define (move-rope movement v)
  (define new-rope (move-tail (move-head movement (visits-rope v))))
  (visits (set-add (visits-visited v) (rope-tail new-rope)) new-rope))

(define (move-tail curr-rope)
  (define dist-posn (pair-dist (rope-tail curr-rope) (rope-head curr-rope)))
  (define dist (posn-length dist-posn))
  (cond
    [(>= dist 2)
     (define tail (rope-tail curr-rope))
     (define normed (norm dist-posn))
     (define new-tail (posn (+ (posn-x normed) (posn-x tail)) (+ (posn-y normed) (posn-y tail))))
     (rope (rope-head curr-rope) new-tail)]
    [else curr-rope]))

(define (move-head movement curr-rope)
  (rope (move-posn (rope-head curr-rope) movement) (rope-tail curr-rope)))

(define (move-posn p movement)
  (cond
    [(string=? movement "R") (posn (+ (posn-x p) 1) (posn-y p))]
    [(string=? movement "L") (posn (- (posn-x p) 1) (posn-y p))]
    [(string=? movement "U") (posn (posn-x p) (+ (posn-y p) 1))]
    [else (posn (posn-x p) (- (posn-y p) 1))]))

(define (posn-length p)
  (sqrt (+ (expt (posn-x p) 2) (expt (posn-y p) 2))))

(define (norm p)
  (define x (if (= 0 (posn-x p)) (posn-x p) (/ (posn-x p) (magnitude (posn-x p)))))
  (define y (if (= 0 (posn-y p)) (posn-y p) (/ (posn-y p) (magnitude (posn-y p)))))
  (posn x y))

(define (pair-dist a b)
  (posn (- (posn-x b) (posn-x a)) (- (posn-y b) (posn-y a))))

(define (line->movements line movements)
  (define split (string-split line))
  (append movements (build-list (string->number (car (cdr split))) (const (car split)))))

;; PART TWO

(struct long-rope (parts) #:transparent)

(define (part-two start-rope movements)
  (set-count (visits-visited (foldl move-long-rope (visits (set) start-rope) movements))))

(define (move-long-rope movement v)
  (define new-rope (move-long-rope-helper movement (visits-rope v)))
  (visits (set-add (visits-visited v) (last (long-rope-parts new-rope))) new-rope))

(define (init-long-rope size)
  (long-rope (build-list size (const (posn 0 0)))))

(define (move-long-rope-helper movement lr)
  (long-rope (move-parts movement '() (long-rope-parts lr))))

(define (move-parts movement last-parts current-parts)
  (cond
    [(null? current-parts) (reverse last-parts)]
    [(null? last-parts)
     (define first-chain (car current-parts))
     (define second-chain (car (cdr current-parts)))
     (define rest-chain (cdr (cdr current-parts)))
     (define sub-rope (rope first-chain second-chain))
     (define sub-rope-move (move-tail (move-head movement sub-rope)))
     (define new-last-parts
       (cons (rope-tail sub-rope-move) (cons (rope-head sub-rope-move) last-parts)))
     (move-parts movement new-last-parts rest-chain)]
    [else
     (define first-chain (car last-parts))
     (define second-chain (car current-parts))
     (define rest-chain (cdr current-parts))
     (define sub-rope (rope first-chain second-chain))
     (define sub-rope-move (move-tail sub-rope))
     (define new-last-parts (cons (rope-tail sub-rope-move) last-parts))
     (move-parts movement new-last-parts rest-chain)
     (move-parts movement new-last-parts rest-chain)]))
