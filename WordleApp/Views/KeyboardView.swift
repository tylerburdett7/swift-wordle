//
//  KeyboardView.swift
//  WordleApp
//
//  Created by Tyler Burdett on 10/15/25.
//

import SwiftUI

struct KeyboardView: View {
    @ObservedObject var game: WordleGame

    // QWERTY layout
    private let rows = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M"]
    ]

    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(row, id: \.self) { letter in
                        Button {
                            game.addLetter(Character(letter))
                        } label: {
                            Text(letter)
                                .frame(width: 32, height: 45)
                                .background(color(for: letter))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                }
            }

            HStack {
                Button("⌫") {
                    game.removeLetter()
                }
                .frame(width: 60, height: 45)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(6)
                .foregroundColor(.white)

                Button("Enter") {
                    game.submitGuess()
                }
                .frame(width: 80, height: 45)
                .background(Color.blue)
                .cornerRadius(6)
                .foregroundColor(.white)
            }
            .padding(.top, 4)
        }
        .padding(.top)
    }

    private func color(for key: String) -> Color {
        switch game.keyboardState[key] {
        case .some(.correct):
            return .green
        case .some(.present):
            return .yellow
        case .some(.absent):
            return .gray.opacity(0.3) // lighter gray for wrong letters
        default:
            return .gray.opacity(0.8) // darker gray for unused keys
        }
    }

}
