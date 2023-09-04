//  ContentView.swift
//  NumberGuesser
//
//  Created by Boris Vedernikov on 02/09/2023.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @State private var playerName = ""
    @State private var guess = ""
    @State private var feedback = ""
    @State private var numberOfGuesses = 0
    @State private var computerNumber = NumberGuesserGame.generateComputerNumber()
    @State private var isGameOver = false
    @State private var userScore: Float = 0.0
    @State private var bestScore: Int = 0
    @State private var appleSignInDelegated: Bool = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    private let gradientBackground: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                titleText
                
                if !isGameOver {
                    inputSection
                    feedbackSection
                    navigationLinkToRating
                    startGameButton
                } else {
                    gameOverSection
                }
            }
            .padding()
            .background(gradientBackground)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var titleText: some View {
        Text("Number Guesser Game")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(Color.blue)
    }
    
    private var inputSection: some View {
        Group {
            HStack {
                TextField("Name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Confirm") {
                    if !playerName.isEmpty {
                        appleSignInDelegated = true
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if !appleSignInDelegated {
                SignInWithAppleButton(.continue, onRequest: requestAppleID, onCompletion: handleAppleIDRequest)
                    .frame(height: 45)
                    .padding()
            }
            
            Text("Enter your guess:")
            TextField("Guess", text: $guess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Submit Guess", action: checkGuess)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    func requestAppleID(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }
    
    func handleAppleIDRequest(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential, let name = appleIDCredential.fullName?.givenName else {
                return
            }
            playerName = name
            appleSignInDelegated = true
            
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
            appleSignInDelegated = false
        }
    }
    
    
    private var feedbackSection: some View {
        VStack {
            Text("Feedback: \(feedback)")
                .font(.headline)
                .foregroundColor(.red)
            
            Text("Number of Guesses: \(numberOfGuesses)")
        }
    }
    
    private var navigationLinkToRating: some View {
        NavigationLink(destination: RatingView().environment(\.managedObjectContext, self.managedObjectContext)) {
            Text("RATING TABLE")
                .font(.title2)
                .foregroundColor(Color.blue)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }
    
    private var startGameButton: some View {
        Button(action: newGameWithHardcodedNumber) {
            Text("START A GAME WITH 1234")
                .font(.title2)
                .fontWeight(.light)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.black]), startPoint: .leading, endPoint: .trailing))
        .foregroundColor(.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple.opacity(0.7), lineWidth: 2))
        .shadow(color: .blue.opacity(0.7), radius: 5, x: 0, y: 2)
    }
    
    private var gameOverSection: some View {
        VStack {
            Text("Game Over!")
                .font(.headline)
                .padding()
            
            Text("Your Score: \(Int(userScore))")
                .padding()
            
            Text("Best Score: \(bestScore)")
            
            Button("Clear database", action: DataController().deleteAllResults)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            Button("New Game", action: newGame)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    
    func checkGuess() {
        let didEndGame = NumberGuesserGame.checkGuess(playerName: playerName, guess: guess, computerNumber: computerNumber, numberOfGuesses: &numberOfGuesses, bestScore: &bestScore, isGameOver: &isGameOver, feedback: &feedback, userScore: &userScore)
        
        if didEndGame {
            DataController().addResult(name: playerName, finalScore: userScore, context: managedObjectContext)
            if let best = DataController().fetchBestScore(for: playerName) {
                bestScore = best
            }
        }
    }
    
    func newGame() {
        NumberGuesserGame.newGame(playerName: &playerName, guess: &guess, feedback: &feedback, numberOfGuesses: &numberOfGuesses, computerNumber: &computerNumber, isGameOver: &isGameOver)
        appleSignInDelegated = false
    }
    
    func newGameWithHardcodedNumber() {
        NumberGuesserGame.newGameWithHardcodedNumber(playerName: &playerName, guess: &guess, feedback: &feedback, numberOfGuesses: &numberOfGuesses, computerNumber: &computerNumber, isGameOver: &isGameOver)
        appleSignInDelegated = false
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        RatingView()
    }
}
