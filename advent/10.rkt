#lang racket/base

(require (only-in racket file->lines string-split flatten take last string-join)
         racket/set)

(define FILE "input/10.txt")
(define TEST-FILE "input/10-test.txt")

;; MAIN
(module+ main
  (define instructions (flatten (map line->instr (file->lines FILE))))
  (define clock (circuit 1 1))
  (define cycles (set 20 60 100 140 180 220))
  (information-signal (foldl signal-strength (information clock cycles 0) instructions))
  (displayln (string-join (crt-pixels (foldl render (crt clock (list)) instructions)) "")))

;; PART ONE
(struct information (circuit cycles signal) #:transparent)
(struct circuit (cycle value) #:transparent)
(struct noop (cycles) #:transparent)
(struct addx (cycles value) #:transparent)

(define (signal-strength instr info)
  (define new-circuit (apply-instr instr (information-circuit info)))
  (if (set-member? (information-cycles info) (circuit-cycle new-circuit))
      (information new-circuit
                   (information-cycles info)
                   (+ (information-signal info)
                      (* (circuit-value new-circuit) (circuit-cycle new-circuit))))
      (information new-circuit (information-cycles info) (information-signal info))))

(define (apply-instr instr circ)
  (if (noop? instr)
      (if (> (noop-cycles instr) 0)
          (apply-instr (noop (- (noop-cycles instr) 1))
                       (circuit (+ (circuit-cycle circ) 1) (circuit-value circ)))
          circ)
      (if (> (addx-cycles instr) 0)
          (apply-instr (addx (- (addx-cycles instr) 1) (addx-value instr))
                       (circuit (+ (circuit-cycle circ) 1) (circuit-value circ)))
          (circuit (circuit-cycle circ) (+ (circuit-value circ) (addx-value instr))))))

(define (line->instr line)
  (define parts (string-split line))
  (if (string=? "noop" (car parts))
      (noop 1)
      (cons (noop 1) (addx 1 (string->number (car (cdr parts)))))))

;; PART TWO
(struct crt (circuit pixels) #:transparent)

(define (render instr tv)
  (define circ (crt-circuit tv))
  (crt (apply-instr instr circ) (append (crt-pixels tv) (list (render-circuit circ)))))

(define (render-circuit circ)
  (define position (modulo (- (circuit-cycle circ) 1) 40))
  (define show-sprite (<= (magnitude (- position (circuit-value circ))) 1))
  (define new-line (= position 39))
  (if show-sprite (if new-line "#\n" "#") (if new-line ".\n" ".")))
