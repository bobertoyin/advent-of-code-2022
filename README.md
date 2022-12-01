# Advent of Code 2022: Causing a Racket

Solutions for [Advent of Code 2022](https://adventofcode.com/2022), done in [Racket](https://racket-lang.org).

## Rationale

Racket. Huh. Racket doesn't seem to be a historically popular choice for Advent of Code[^1], but I figured I'd take 25 days out of my year to try something new. 

Here's why I'm choosing Racket for Advent of Code 2022:

1. I'm familiar with Racket's syntax and some of its offshoots.

    - I got acquainted with Racket's [student languages](https://docs.racket-lang.org/htdp-langs/index.html) during the Fall of my freshman year. Prefix notation and parantheses shan't scare me away.

2. The full Racket experience is completely new to me.

    - This'll be my first time having all of `#lang racket` at my disposal. 

3. I'd like to spend some more time in the functional programming world.

    - I'm used to applying functional programming styles to langauges like Python, but I think it'll be a little easier to adhere to this practice by using a language that heavily supports and advocates for it.

4. I'd like to keep my syntax and programming concepts simple.

    - As much as I've enjoyed tinkering with Rust and thinking about Go, Haskell, or other cool languages (I rival Hamlet in the practice of inaction[^2] here), the overhead and learning curve for most of those languages would be too much for me right now. I'd love to learn how to apply Go's concurrency model or Haskell's lazy evaluation to Advent of Code, but getting bitten by Rust's borrow checker, Go's error handling, or Haskell's monad system should be saved for another time of the year.
    - I'm also choosing to use languages that are more script-oriented than project-oriented, while also trying to learn something new. Thus, although I've gotten used to plenty of Python, it'll have to be saved for other endeavors.

## File Structure

> `(day)` is the numerical value for each day.

Each day's implementation code is located in `advent/(day).rkt`, with simple "tests" (depending on how lazy I get) in `advent/(day)-test.rkt`.

Each day's file input is located in `input/(day).txt`, with the simple test input (provided by Advent of Code) in `input/(day)-test.txt`

## Runtime Performance Table

> `(day)` is the numerical value for each day.

This is mostly meaningless, but also somewhat harmless. 

Times are recorded using `time racket advent/(day).rkt`.

Day | Time (Seconds)
--- | --------------
1   | ~0.35s

## Footnotes

[^1]: https://masalmon.eu/2018/12/15/adventofcode
[^2]: https://www.litcharts.com/lit/hamlet/themes/action-and-inaction