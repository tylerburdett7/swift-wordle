import SwiftUI
import Supabase

struct ContentView: View {
    
    @StateObject var game = WordleGame()
    @StateObject var gameCenter = GameCenterManager.shared
    
    @State private var showLeaderboard = false

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

            Button("Leaderboard") {
                showLeaderboard = true
            }
            .padding(.bottom)
        }
        .onAppear {
            gameCenter.authenticate()
            Task {
                await SupabaseManager.shared.addTestPlayer()
            }
        }
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
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
