//
//  ContentView.swift
//  WordleApp
//
//  Created by Tyler Burdett on 10/15/25.
//

import SwiftUI
import Supabase

struct ContentView: View {
    @StateObject var game = WordleGame()

    var body: some View {
        VStack {
            Text("Wordle")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            // Display previous guesses
            ForEach(game.guesses, id: \.self) { row in
                HStack {
                    ForEach(row) { tile in
                        Text(String(tile.letter))
                            .frame(width: 40, height: 40)
                            .background(color(for: tile.result))
                            .cornerRadius(6)
                            .foregroundColor(.white)
                    }
                }
            }

            // Display current guess row
            HStack {
                ForEach(Array(game.currentGuess), id: \.self) { char in
                    Text(String(char))
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                }
            }

            // Display message
            if let msg = game.message {
                Text(msg)
                    .padding()
            }

            // Keyboard
            KeyboardView(game: game)

            // Reset button
            Button("Reset Game") {
                game.resetGame()
            }
            .padding()
        }
        // ✅ This runs once when the app starts
        .onAppear {
            Task {
                await SupabaseManager.shared.addTestPlayer()
            }
        }
    }

    // MARK: - Helper function for tile colors
    func color(for result: LetterResult) -> Color {
        switch result {
        case .correct: return .green
        case .present: return .yellow
        case .absent: return .gray.opacity(0.3)
        case .unknown: return .secondary
        }
    }
}
