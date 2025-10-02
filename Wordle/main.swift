//
//  main.swift
//  Wordle
//
//  Created by Tyler Burdett on 9/29/25.
//

import Foundation

let words = ["SWIFT", "CODES", "APPLE", "MOUSE", "STACK"]

let answer = words.randomElement()!
let maxAttempts = 6

print("Welcome to Wordle")
print("Guess the 5-letter word. You have \(maxAttempts) tries.\n")

for attempt in 1...maxAttempts {
    print("Attempt \(attempt): ", terminator: "")
    guard let guess = readLine()?.uppercased(), guess.count == 5 else {
        print ("Invalid guess. Enter a 5-letter word ")
        continue
    }
    
    if guess == answer {
        print ("✅✅✅✅✅")
        print("\nYou guessed it! The word was \(answer).")
        break
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

