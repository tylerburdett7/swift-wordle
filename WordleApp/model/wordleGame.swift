//
//  WordleGame.swift
//  WordleApp
//
//  Created by Tyler Burdett on 10/15/25.
//

import Foundation
import SwiftUI
import Combine
import Supabase

enum LetterResult {
    case correct, present, absent, unknown
}

struct LetterTile: Identifiable, Hashable {
    let id = UUID()
    let letter: Character
    let result: LetterResult
}

@MainActor
class WordleGame: ObservableObject {
    @Published var secretWord: String = "SWIFT"
    @Published var currentGuess: String = ""
    @Published var guesses: [[LetterTile]] = []
    @Published var message: String?
    @Published var isGameOver: Bool = false
    @Published var didWin: Bool = false
    @Published var keyboardState: [String: LetterResult] = [:]

    let maxAttempts = 6

    init() {
        fetchRandomWord()
    }

    func fetchRandomWord() {
        WordFetcher.fetchRandomWord { [weak self] word in
            Task { @MainActor in
                self?.secretWord = word ?? "SWIFT"
            }
        }
    }

    func addLetter(_ char: Character) {
        guard !isGameOver else { return }
        guard currentGuess.count < 5 else { return }
        currentGuess.append(char)
    }

    func removeLetter() {
        guard !isGameOver else { return }
        if !currentGuess.isEmpty {
            currentGuess.removeLast()
        }
    }

    func submitGuess() {
        guard !isGameOver else { return }
        guard currentGuess.count == 5 else {
            message = "Enter a 5-letter word."
            return
        }

        let guess = currentGuess.uppercased()

        let evaluation = evaluate(guess: guess)
        guesses.append(evaluation)
        updateKeyboardState(with: evaluation)
        currentGuess = ""

        if guess == secretWord {
            isGameOver = true
            didWin = true
            message = "✅ You guessed it!"
            Task {
                await recordGameResult(didWin: true)
            }
        } else if guesses.count == maxAttempts {
            isGameOver = true
            message = "❌ Out of tries! The word was \(secretWord)."
            Task {
                await recordGameResult(didWin: false)
            }
        }
    }

    func evaluate(guess: String) -> [LetterTile] {
        var result: [LetterTile] = []
        for (gChar, aChar) in zip(guess, secretWord) {
            if gChar == aChar {
                result.append(LetterTile(letter: gChar, result: .correct))
            } else if secretWord.contains(gChar) {
                result.append(LetterTile(letter: gChar, result: .present))
            } else {
                result.append(LetterTile(letter: gChar, result: .absent))
            }
        }
        return result
    }

    func updateKeyboardState(with tiles: [LetterTile]) {
        for tile in tiles {
            let key = String(tile.letter)
            let currentState = keyboardState[key] ?? .unknown

            // Prioritize colors correctly: correct > present > absent
            switch (currentState, tile.result) {
            case (_, .correct):
                keyboardState[key] = .correct
            case (.unknown, .present), (.absent, .present):
                keyboardState[key] = .present
            case (.unknown, .absent):
                keyboardState[key] = .absent
            default:
                break
            }
        }
    }

    func resetGame() {
        guesses.removeAll()
        currentGuess = ""
        message = nil
        isGameOver = false
        didWin = false
        keyboardState.removeAll()
        fetchRandomWord()
    }

    // 🟢 Record the game result to Supabase
    func recordGameResult(didWin: Bool) async {
        struct GameRecord: Encodable {
            let player_name: String
            let did_win: Bool
            let word: String
            let attempts: Int
            let timestamp: String
        }

        do {
            let client = SupabaseManager.shared.client

            let record = GameRecord(
                player_name: "Test Player",
                did_win: didWin,
                word: secretWord,
                attempts: guesses.count,
                timestamp: ISO8601DateFormatter().string(from: Date())
            )

            _ = try await client
                .from("games")
                .insert(record)
                .execute()

            print("✅ Game result recorded in Supabase")
        } catch {
            print("❌ Failed to record game result:", error.localizedDescription)
        }
    }

}
