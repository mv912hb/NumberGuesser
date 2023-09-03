//
//  NumberGuesserGame.swift
//  NumberGuesser
//
//  Created by Boris Vedernikov on 02/09/2023.
//

import Foundation
import CoreData

struct NumberGuesserGame {
    
    @discardableResult
    static func checkGuess(playerName: String, guess: String, computerNumber: String, numberOfGuesses: inout Int, bestScore: inout Int, isGameOver: inout Bool, feedback: inout String, userScore: inout Float) -> Bool {
        guard guess.count == 4, Set(guess).count == 4 else {
            feedback = "Guess must be a 4-digit number without duplicates"
            return false
        }
        
        var correctDigits = 0
        var misplacedDigits = 0
        let userGuess = Array(guess)
        let computerGuess = Array(computerNumber)
        
        for (index, digit) in userGuess.enumerated() {
            if digit == computerGuess[index] {
                correctDigits += 1
            } else if computerGuess.contains(digit) {
                misplacedDigits += 1
            }
        }
        if correctDigits == 4 {
            feedback = "You've guessed the correct number!"
            isGameOver = true
            numberOfGuesses += 1
            userScore = Float(100 - (numberOfGuesses * 2))
            return true
        } else {
            feedback = "\(correctDigits) + \(misplacedDigits) -"
            numberOfGuesses += 1
            return false
        }
    }
    
    static func generateComputerNumber() -> String {
        var numbers = Array(0...9)
        numbers.shuffle()
        let result = numbers.prefix(4).map { String($0) }
        return result.joined()
    }
    
    static func newGame(playerName: inout String, guess: inout String, feedback: inout String, numberOfGuesses: inout Int, computerNumber: inout String, isGameOver: inout Bool) {
        playerName = ""
        guess = ""
        feedback = ""
        numberOfGuesses = 0
        computerNumber = generateComputerNumber()
        isGameOver = false
    }
    
    static func newGameWithHardcodedNumber(playerName: inout String, guess: inout String, feedback: inout String, numberOfGuesses: inout Int, computerNumber: inout String, isGameOver: inout Bool) {
        playerName = ""
        guess = ""
        feedback = ""
        numberOfGuesses = 0
        computerNumber = "1234"
        isGameOver = false
    }
}


