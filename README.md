# Advent of Code 2022: Causing a Racket

Solutions for [Advent of Code 2022](https://adventofcode.com/2022), done in [Racket](https://racket-lang.org).

## Rationale

Racket. Huh. Racket doesn't seem to be a historically popular choice for Advent of Code[^1], but I figured I'd take 25 days out of my year to try something new. 

Here's why I'm choosing Racket for Advent of Code 2022:

1. To explore a new language ecosystem while maintaining familiarity with syntax and fundamentals.

    - I've used Racket's [student languages](https://docs.racket-lang.org/htdp-langs/index.html) 
    during my first year of undergrad, but this'll be the first time that I have all of `#lang racket` 
    (or more realistically, `#lang racket/base` with some `require` statements) at my disposal.

2. To practice functional programming.

    - While Racket does support other programming paradigms, a lot of the standard library and core language is built for functional programming.
    And while I'm used to using functional programming in more mainstream langauages, I figure it's good to practice anyways.

3. To keep solutions as simple scripting files.

    - Outside of declaring a "main" module and helper functions for code organization, being able to avoid heavy code boilerplate/overhead and strict file/directory requirements allows me to keep this repository lean and simple.

4. To avoid overkill language features.

    - This is not to say that Racket *isn't* a language with many features or third-party libraries, but instead that Racket's core language and standard library should be lean enough to solve the puzzles without loading up on excessive or high-learning curve features.

## File Structure

> `(day)` is the numerical value for each day.

Each day's implementation code is located in `advent/(day).rkt`, with simple "tests" (depending on how lazy I get) in `test/(day).rkt`.

Each day's file input is located in `input/(day).txt`, with the simple test input (provided by Advent of Code) in `input/(day)-test.txt`.

## Tests

The simple "tests" can all be run with `./test.sh`.

## Completion Dates

Day | Completion Date
--- | ---------------
1   | Dec. 1, 2022
2   | Dec. 2, 2022
3   | Dec. 3, 2022
4   | Dec. 4, 2022
5   | Dec. 5, 2022
6   | Dec. 6, 2022
7   | Dec. 7, 2022
8   | Dec. 8, 2022
9   | Dec. 9, 2022
10  | Dec. 10, 2022

## Footnotes

[^1]: https://masalmon.eu/2018/12/15/adventofcode
[^2]: https://www.litcharts.com/lit/hamlet/themes/action-and-inaction