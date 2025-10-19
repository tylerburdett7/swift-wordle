//
//  wordFetcher.swift
//  WordleApp
//
//  Created by Tyler Burdett on 10/15/25.
//

import Foundation

struct WordFetcher {
    static func fetchRandomWord(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://random-word-api.herokuapp.com/word?length=5") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let words = try? JSONSerialization.jsonObject(with: data) as? [String],
               let word = words.first {
                completion(word.uppercased())
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

