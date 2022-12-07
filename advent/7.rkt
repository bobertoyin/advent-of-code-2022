#lang racket/base

(require (only-in racket file->lines partition string-split first second third flatten))

(define FILE "input/7.txt")
(define TEST-FILE "input/7-test.txt")

;; MAIN
(module+ main
  (define commands (map string-split (file->lines FILE)))
  (define file-dir (foldl build-directory (directory "/" #f '() '()) commands))
  (dir-total-size-less-than file-dir 100000)
  (apply min (flatten (free-enough-space file-dir (current-unused file-dir 70000000) 30000000))))

;; PART ONE

(struct directory (name working children files) #:transparent)
(struct file (name size) #:transparent)

(define (dir-total-size-less-than dir less-than)
  (define inclusion (if (<= (total-size dir) less-than) (total-size dir) 0))
  (+ inclusion
     (foldr +
            0
            (map (lambda (child) (dir-total-size-less-than child less-than))
                 (directory-children dir)))))

(define (total-size dir)
  (+ (foldr + 0 (map total-size (directory-children dir)))
     (foldr + 0 (map file-size (directory-files dir)))))

(define (build-directory command dir)
  (define first-token (first command))
  (define second-token (second command))
  (cond
    [(and (string=? first-token "$") (string=? second-token "cd"))
     (define third-token (third command))
     (cond
       [(string=? third-token "..") (directory-up dir)]
       [(string=? third-token "/") (directory-root dir)]
       [else (directory-down dir third-token)])]
    [(string=? first-token "$") dir]
    [(string=? first-token "dir") (add-directory dir (directory second-token #f '() '()))]
    [else (add-file dir (file second-token (string->number first-token)))]))

(define (add-file dir new-file)
  (if (directory-working dir)
      (directory (directory-name dir)
                 (directory-working dir)
                 (directory-children dir)
                 (cons new-file (directory-files dir)))
      (directory (directory-name dir)
                 (directory-working dir)
                 (map (lambda (child) (add-file child new-file)) (directory-children dir))
                 (directory-files dir))))

(define (add-directory dir new-dir)
  (if (directory-working dir)
      (directory (directory-name dir)
                 (directory-working dir)
                 (cons new-dir (directory-children dir))
                 (directory-files dir))
      (directory (directory-name dir)
                 (directory-working dir)
                 (map (lambda (child) (add-directory child new-dir)) (directory-children dir))
                 (directory-files dir))))

(define (directory-root dir)
  (directory (directory-name dir)
             #t
             (map non-working-cascade (directory-children dir))
             (directory-files dir)))

(define (directory-down dir name)
  (if (directory-working dir)
      (directory (directory-name dir)
                 #f
                 (map (lambda (child) (make-working child name)) (directory-children dir))
                 (directory-files dir))
      (directory (directory-name dir)
                 #f
                 (map (lambda (child) (directory-down child name)) (directory-children dir))
                 (directory-files dir))))

(define (make-working dir name)
  (if (string=? (directory-name dir) name)
      (directory (directory-name dir) #t (directory-children dir) (directory-files dir))
      dir))

(define (directory-up dir)
  (if (foldr (lambda (one two) (or one two)) #f (map directory-working (directory-children dir)))
      (directory (directory-name dir)
                 #t
                 (map non-working-cascade (directory-children dir))
                 (directory-files dir))
      (directory (directory-name dir)
                 #f
                 (map directory-up (directory-children dir))
                 (directory-files dir))))

(define (non-working-cascade dir)
  (directory (directory-name dir)
             #f
             (map non-working-cascade (directory-children dir))
             (directory-files dir)))

;; PART TWO
(define (current-unused dir total)
  (- total (total-size dir)))

(define (free-enough-space dir current-unused free-required)
  (if (>= (+ current-unused (total-size dir)) free-required)
      (cons (total-size dir)
            (map (lambda (child) (free-enough-space child current-unused free-required))
                 (directory-children dir)))
      (map (lambda (child) (free-enough-space child current-unused free-required))
           (directory-children dir))))
