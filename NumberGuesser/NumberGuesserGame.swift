//
//  NumberGuesserGame.swift
//  NumberGuesser
//
//  Created by Boris Vedernikov on 02/09/2023.
//

import Foundation

struct NumberGuesserGame {
    
    @discardableResult
    static func checkGuess(playerName: String, guess: String, computerNumber: String, numberOfGuesses: inout Int, bestScore: inout Int, isGameOver: inout Bool, feedback: inout String, userScore: inout Float) -> Bool {
        
        guard isValid(guess: guess) else {
            feedback = "Guess must be a 4-digit number without duplicates"
            return false
        }
        
        let (correctDigits, misplacedDigits) = compareGuesses(userGuess: guess, computerGuess: computerNumber)
        
        numberOfGuesses += 1
        
        if correctDigits == 4 {
            feedback = "You've guessed the correct number!"
            isGameOver = true
            userScore = Float(100 - (numberOfGuesses * 2))
            return true
        } else {
            feedback = "\(correctDigits) + \(misplacedDigits) -"
            return false
        }
    }
    
    static func generateComputerNumber() -> String {
        var numbers = Array(0...9)
        numbers.shuffle()
        return numbers.prefix(4).map(String.init).joined()
    }
    
    static func newGame(playerName: inout String, guess: inout String, feedback: inout String, numberOfGuesses: inout Int, computerNumber: inout String, isGameOver: inout Bool) {
        resetGame(for: &playerName, guess: &guess, feedback: &feedback, numberOfGuesses: &numberOfGuesses, computerNumber: &computerNumber, isGameOver: &isGameOver, newNumber: generateComputerNumber())
    }
    
    static func newGameWithHardcodedNumber(playerName: inout String, guess: inout String, feedback: inout String, numberOfGuesses: inout Int, computerNumber: inout String, isGameOver: inout Bool) {
        resetGame(for: &playerName, guess: &guess, feedback: &feedback, numberOfGuesses: &numberOfGuesses, computerNumber: &computerNumber, isGameOver: &isGameOver, newNumber: "1234")
    }
    
    private static func isValid(guess: String) -> Bool {
        return guess.count == 4 && Set(guess).count == 4
    }
    
    private static func compareGuesses(userGuess: String, computerGuess: String) -> (Int, Int) {
        var correctDigits = 0
        var misplacedDigits = 0
        let userGuessArray = Array(userGuess)
        let computerGuessArray = Array(computerGuess)
        
        for (index, digit) in userGuessArray.enumerated() {
            if digit == computerGuessArray[index] {
                correctDigits += 1
            } else if computerGuessArray.contains(digit) {
                misplacedDigits += 1
            }
        }
        return (correctDigits, misplacedDigits)
    }
    
    private static func resetGame(for playerName: inout String, guess: inout String, feedback: inout String, numberOfGuesses: inout Int, computerNumber: inout String, isGameOver: inout Bool, newNumber: String) {
        playerName = ""
        guess = ""
        feedback = ""
        numberOfGuesses = 0
        computerNumber = newNumber
        isGameOver = false
    }
}
