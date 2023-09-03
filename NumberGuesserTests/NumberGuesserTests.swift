//
//  NumberGuesserTests.swift
//  NumberGuesserTests
//
//  Created by Boris Vedernikov on 02/09/2023.
//

@testable import NumberGuesser // Make sure to replace "NumberGuesser" with the name of your module if different
import XCTest
import CoreData

class NumberGuesserTests: XCTestCase {
    
    var dataController: DataController!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        dataController = DataController()
        mockContext = dataController.container.newBackgroundContext()
    }
    
    override func tearDown() {
        dataController = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testNumberGeneration() {
        let number = NumberGuesserGame.generateComputerNumber()
        XCTAssertEqual(number.count, 4, "Generated number should have 4 digits")
        XCTAssertEqual(Set(number).count, 4, "Generated number should have distinct digits")
    }
    
    func testCorrectGuess() {
        var feedback = ""
        var isGameOver = false
        var userScore: Float = 0.0
        var numberOfGuesses = 0
        var bestScore = 0

        let didEndGame = NumberGuesserGame.checkGuess(
            playerName: "TestPlayer",
            guess: "1273",
            computerNumber: "1273",
            numberOfGuesses: &numberOfGuesses,
            bestScore: &bestScore,
            isGameOver: &isGameOver,
            feedback: &feedback,
            userScore: &userScore
        )

        XCTAssertTrue(didEndGame)
        XCTAssertEqual(feedback, "You've guessed the correct number!")
    }
    
    func testAddResult() {
        let playerName = "TestPlayer1"
        let finalScore: Float = 88.0
        let localMockContext = dataController.container.newBackgroundContext()
        
        dataController.addResult(name: playerName, finalScore: finalScore, context: localMockContext)
        
        let fetchRequest: NSFetchRequest<GameResult> = GameResult.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", playerName)
        
        do {
            let results = try localMockContext.fetch(fetchRequest)
            XCTAssertNotNil(results.first)
            XCTAssertEqual(results.first?.score, finalScore)
        } catch {
            XCTFail("Failed to fetch added result")
        }
    }

    func testFetchBestScore() {
        let playerName = "TestPlayer2"
        let localMockContext = dataController.container.newBackgroundContext()
        let finalScore: Float = 88.0
        
        dataController.addResult(name: playerName, finalScore: finalScore, context: localMockContext)
        guard let score = dataController.fetchBestScore(for: playerName) else {
            XCTFail("Failed to fetch best score for \(playerName)")
            return
        }
        XCTAssertEqual(score, 88)
    }

    
    func testDeleteAllResults() {
        dataController.deleteAllResults()
        let fetchRequest: NSFetchRequest<GameResult> = GameResult.fetchRequest()
        
        do {
            let results = try mockContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 0)
        } catch {
            XCTFail("Failed to fetch results after deletion")
        }
    }
}
