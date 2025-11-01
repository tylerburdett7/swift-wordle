import Foundation

struct WordFetcher {
    static func fetchRandomWord(completion: @escaping (String?) -> Void) {
        // Try loading from the Wordle answers text file first
        if let path = Bundle.main.path(forResource: "wordle-answers", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: path, encoding: .utf8)
                let words = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
                if let randomWord = words.randomElement() {
                    completion(randomWord.uppercased())
                    return
                }
            } catch {
                print("❌ Failed to read word list: \(error)")
            }
        }

        // Fallback to API if the file can’t be read
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
