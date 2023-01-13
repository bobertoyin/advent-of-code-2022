#lang racket/base

(require (only-in racket file->lines first take take-right)
         racket/set)

(define FILE "input/6.txt")
(define TEST-FILE "input/6-test.txt")

;; MAIN
(module+ main
  (define buffer (read-buffer FILE))
  (min-window-index buffer 0 4)
  (min-window-index buffer 0 14))

;; PART ONE AND TWO

(define (read-buffer FILE-PATH)
  (string->list (first (file->lines FILE-PATH))))

(define (min-window-index buffer num-processed window-size)
  (cond
    [(< num-processed window-size) (min-window-index buffer (+ 1 num-processed) window-size)]
    [else
     (define window (list-tail (take buffer num-processed) (- num-processed window-size)))
     (if (and (= (length window) window-size) (= (length window) (set-count (list->set window))))
         num-processed
         (min-window-index buffer (+ 1 num-processed) window-size))]))
