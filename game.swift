//
//  Game.swift
//  Wordle
//

import Foundation

func runGame(answer: String) {
    let maxAttempts = 6
    print("\nWelcome to Wordle")
    print("Guess the 5-letter word. You have \(maxAttempts) tries.\n")

    for attempt in 1...maxAttempts {
        print("Attempt \(attempt): ", terminator: "")
        guard let guess = readLine()?.uppercased(), guess.count == 5 else {
            print("Invalid guess. Enter a 5-letter word.")
            continue
        }
        
        if guess == answer {
            print("✅✅✅✅✅")
            print("\nYou guessed it! The word was \(answer).")
            return
        }
        
        var result = ""
        for (gChar, aChar) in zip(guess, answer) {
            if gChar == aChar {
                result.append("✅")
            } else if answer.contains(gChar) {
                result.append("🟨")
            } else {
                result.append("⬜️")
            }
        }
        
        print(result)
        
        if attempt == maxAttempts {
            print("❌ Out of tries! The word was \(answer).")
        }
    }
}

func main() {
    repeat {
        let group = DispatchGroup()
        group.enter()
        
        fetchRandomWord { word in
            if let answer = word {
                runGame(answer: answer)
            } else {
                runGame(answer: "SWIFT") // fallback
            }
            group.leave()
        }
        
        group.wait() // wait for word fetch before next round
        
        print("\nPlay again? (y/n): ", terminator: "")
        let response = readLine()?.lowercased()
        if response != "y" {
            break
        }
    } while true
}

