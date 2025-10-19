//
//  ContentView.swift
//  WordleApp
//
//  Created by Tyler Burdett on 10/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var game = WordleGame()

    var body: some View {
        VStack {
            Text("Wordle")
                .font(.largeTitle)
                .bold()
                .padding(.top)

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

            HStack {
                ForEach(Array(game.currentGuess), id: \.self) { char in
                    Text(String(char))
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                }
            }

            if let msg = game.message {
                Text(msg)
                    .padding()
            }

            KeyboardView(game: game)

            Button("Reset Game") {
                game.resetGame()
            }
            .padding()
        }
    }

    func color(for result: LetterResult) -> Color {
        switch result {
        case .correct: return .green
        case .present: return .yellow
        case .absent: return .gray.opacity(0.3)
        case .unknown: return .secondary
        }
    }
}
