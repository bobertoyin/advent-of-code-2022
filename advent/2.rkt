#lang racket/base

(require (only-in racket file->lines string-split first last))

(define FILE "input/2.txt")
(provide TEST-FILE)
(define TEST-FILE "input/2-test.txt")

;; MAIN
(module+ main 
    (foldl + 0 (score-interactions FILE))
    (foldl + 0 (score-expectations FILE))
)

;; PART ONE

;; Represents the possible player/opponent choices in the game of Rock, Paper, Scissors.
(define ROCK "rock")
(define PAPER "paper")
(define SCISSORS "scissors")

;; Represents the possible outcomes in the game of Rock, Paper, Scissors.
(define DRAW "draw")
(define LOSE "lose")
(define WIN "win")

;; Create the correct list of inputs from each file. 
;; Effectively just "__ __" -> (list "__" "__") for each line.
;; Path-string -> List[List[String]]
;; Example: "test.txt" -> [["A", "X"], ["B", "Z"], ["C", "Y"]]
(define (create-inputs file-path) (map string-split (file->lines file-path)))

;; Returns the scores of all encrypted game interactions.
;; Takes in the file path containing the encrypted lines of "*opponent* *player*".
;; Path-string -> List[Number]
;; Example: "test.txt" -> [2, 6, 4]
(provide score-interactions)
(define (score-interactions file-path) (map score-interaction (create-inputs file-path)))

;; Score a single encrypted interaction.
;; List[String] -> Number
;; Example: ["A", "X"] -> 4
(define (score-interaction interaction)
    (score-interaction-helper 
        (decrypt-opponent (first interaction)) 
        (decrypt-player (last interaction))
    )
)

;; Score an interaction between a decrypted opponent and decrypted player.
;; String, String -> Number
;; Example: "A", "X" -> 4
(define (score-interaction-helper opponent player)
    (+ 
        (choice-value player) 
        (result-value (interaction-result opponent player))
    )
)

;; Decrypt an opponent's decision.
;; String -> String
;; Example: "A" -> "rock"
(define (decrypt-opponent encrypted)
    (cond
        [(string=? encrypted "A") ROCK]
        [(string=? encrypted "B") PAPER]
        [(string=? encrypted "C") SCISSORS]
    )
)

;; Decrypt a player's decision.
;; String -> String
;; Example: "X" -> "rock"
(define (decrypt-player encrypted)
    (cond
        [(string=? encrypted "X") ROCK]
        [(string=? encrypted "Y") PAPER]
        [(string=? encrypted "Z") SCISSORS]
    )
)

;; Determine the value of a person's choice.
;; String -> Number
;; Example: "rock" -> 1
(define (choice-value choice)
    (cond
        [(string=? choice ROCK) 1]
        [(string=? choice PAPER) 2]
        [(string=? choice SCISSORS) 3]
    )
)

;; Determine the value of a game's result.
;; String -> Number
;; Example: "lose" -> 0
(define (result-value result)
    (cond
        [(string=? result LOSE) 0]
        [(string=? result DRAW) 3]
        [(string=? result WIN) 6]
    )
)

;; Determine the result of a game between a decrypted opponent and decrypted player.
;; String, String -> String
;; Example: "rock", "paper" -> "win"
(define (interaction-result opponent player)
    (cond 
        [(string=? opponent ROCK)
            (cond
                [(string=? player ROCK) DRAW]
                [(string=? player PAPER) WIN]
                [(string=? player SCISSORS) LOSE]
            )
        ]
        [(string=? opponent PAPER)
            (cond
                [(string=? player ROCK) LOSE]
                [(string=? player PAPER) DRAW]
                [(string=? player SCISSORS) WIN]
            )
        ]
        [(string=? opponent SCISSORS)
            (cond
                [(string=? player ROCK) WIN]
                [(string=? player PAPER) LOSE]
                [(string=? player SCISSORS) DRAW]
            )
        ]
    )
)

;; PART TWO

;;; Returns the scores of all encrypted game expectations.
;; Takes in the file path containing the encrypted lines of "*opponent* *result*".
;; Path-string -> List[Number]
;; Example: "test.txt" -> [2, 6, 4]
(provide score-expectations)
(define (score-expectations file-path) (map score-expectation (create-inputs file-path)))

;; Score a single encrypted expectation.
;; List[String] -> Number
;; Example: ["A", "X"] -> 2
(define (score-expectation expectation) 
    (score-expectation-helper 
        (decrypt-opponent (first expectation)) (decrypt-result (last expectation))
    )
)

;; Score an expectation between a decrypted opponent and decrypted result.
;; String, String -> Number
;; Example: "A", "X" -> 2
(define (score-expectation-helper opponent outcome)
    (+ (result-value outcome) (choice-value (player-expectation opponent outcome)))
)

;; Decrypt an expected result.
;; String -> String
;; Example: "X" -> "lose"
(define (decrypt-result encrypted)
    (cond
        [(string=? encrypted "X") LOSE]
        [(string=? encrypted "Y") DRAW]
        [(string=? encrypted "Z") WIN]
    )
)

;; Determine the player choice required to acheive a decrypted outcome against a decrypted opponent.
;; String, String -> String
;; Example: "rock", "win" -> "paper"
(define (player-expectation opponent outcome)
    (cond
        [(string=? outcome DRAW) opponent]
        [(string=? outcome LOSE)
            (cond
                [(string=? opponent ROCK) SCISSORS]
                [(string=? opponent PAPER) ROCK]
                [(string=? opponent SCISSORS) PAPER]
            )
        ]
        [(string=? outcome WIN)
            (cond
                [(string=? opponent ROCK) PAPER]
                [(string=? opponent PAPER) SCISSORS]
                [(string=? opponent SCISSORS) ROCK]
            )
        ]
    )
)
