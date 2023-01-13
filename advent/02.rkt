#lang racket/base

(require (only-in racket file->lines string-split))

(define FILE "input/02.txt")
(provide TEST-FILE)
(define TEST-FILE "input/02-test.txt")

(module+ main
  (evaluate-interactions score-by-outcome FILE)
  (evaluate-interactions score-by-expectation FILE))

;; Represents the possible player/opponent choices in the game of Rock, Paper, Scissors.
(define ROCK "rock")
(define PAPER "paper")
(define SCISSORS "scissors")
;; Represents the possible outcomes in the game of Rock, Paper, Scissors.
(define DRAW "draw")
(define LOSE "lose")
(define WIN "win")
;; Maps an opponent's choice from encrypted representation to decrypted representation.
(define opponent-decrypt-table (hash "A" ROCK "B" PAPER "C" SCISSORS))
;; Maps a player's choice from encrypted representation to decrypted representation.
(define player-decrypt-table (hash "X" ROCK "Y" PAPER "Z" SCISSORS))
;; Maps an interaction's result from encrypted representation to decrypted representation.
(define result-decrypt-table (hash "X" LOSE "Y" DRAW "Z" WIN))
;; Maps a move choice from decrypted representation to value.
(define move-value-table (hash ROCK 1 PAPER 2 SCISSORS 3))
;; Maps an interaction's result from decrypted representation to value.
(define result-value-table (hash LOSE 0 DRAW 3 WIN 6))

#| Evaluate strategy guide interactions based on a specified evaluation rule.

Also takes the input text file representing the strategy guide interactions.

Function[[String, String] -> Number], Path-string -> Number

Example: (lambda pair (+ (length (car pair)) (length (cdr pair)))), "input/test.txt" -> 32
|#
(provide evaluate-interactions)
(define (evaluate-interactions eval file-path)
  (foldl + 0 (map eval (create-inputs file-path))))

#| Create the list of interactions from a given file.

Interactions are represented as pairs of strings.

Path-string -> List[[String, String]]

Example: "test.txt" -> [["A", "X"], ["B", "Z"], ["C", "Y"]]
|#
(define (create-inputs file-path)
  (map (lambda lst (cons (caar lst) (cdar lst))) (map string-split (file->lines file-path))))

#| Score an encrypted interaction based on the outcome.

This means that the interaction represents the opponent's move and the player's move.

[String, String] -> Number

Example: ["A", "Y"] -> 8
|#
(provide score-by-outcome)
(define (score-by-outcome interaction)
  (define opponent (hash-ref opponent-decrypt-table (car interaction)))
  (define player (hash-ref player-decrypt-table (cadr interaction)))
  (+ (hash-ref result-value-table (interaction->result opponent player))
     (hash-ref move-value-table player)))

#| Score an encrypted interaction based on the what the player should do.

This means that the interaction represents the opponent's move and whether the player
should win, draw, or lose.

[String, String] -> Number

Example: ["A", "Y"] -> 4
|#
(provide score-by-expectation)
(define (score-by-expectation interaction)
  (define opponent (hash-ref opponent-decrypt-table (car interaction)))
  (define expectation (hash-ref result-decrypt-table (cadr interaction)))
  (+ (hash-ref result-value-table expectation)
     (hash-ref move-value-table (interaction->expectation opponent expectation))))

#| Determine the result of an interaction.

Takes the decrypted opponent move and the decrypted player move.

[String, String] -> String

Example: ["rock", "scissors"] -> "lose"
|#
(define (interaction->result opponent player)
  (cond
    [(string=? opponent ROCK)
     (cond
       [(string=? player ROCK) DRAW]
       [(string=? player PAPER) WIN]
       [(string=? player SCISSORS) LOSE])]
    [(string=? opponent PAPER)
     (cond
       [(string=? player ROCK) LOSE]
       [(string=? player PAPER) DRAW]
       [(string=? player SCISSORS) WIN])]
    [(string=? opponent SCISSORS)
     (cond
       [(string=? player ROCK) WIN]
       [(string=? player PAPER) LOSE]
       [(string=? player SCISSORS) DRAW])]))

#| Determine the required player move for a desired outcome.

Takes the decrypted opponent move and the decrypted expected outcome.

[String, String] -> String

Example: ["rock", "lose"] -> "scissors"
|#
(define (interaction->expectation opponent outcome)
  (cond
    [(string=? outcome DRAW) opponent]
    [(string=? outcome LOSE)
     (cond
       [(string=? opponent ROCK) SCISSORS]
       [(string=? opponent PAPER) ROCK]
       [(string=? opponent SCISSORS) PAPER])]
    [(string=? outcome WIN)
     (cond
       [(string=? opponent ROCK) PAPER]
       [(string=? opponent PAPER) SCISSORS]
       [(string=? opponent SCISSORS) ROCK])]))
