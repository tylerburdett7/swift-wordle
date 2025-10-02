//
//  WordFetcher.swift
//  Wordle
//

import Foundation

func fetchRandomWord(completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://random-word-api.herokuapp.com/word?length=5")!
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching word: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        if let words = try? JSONSerialization.jsonObject(with: data, options: []) as? [String],
           let word = words.first {
            completion(word.uppercased())
        } else {
            completion(nil)
        }
    }
    
    task.resume()
}

