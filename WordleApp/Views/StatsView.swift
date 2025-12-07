//
//  StatsView.swift
//  WordleApp
//
//  Created by Tyler Burdett on 12/3/25.
//

import SwiftUI

struct StatsView: View {
    @State private var stats: PlayerStats?
    @State private var isLoading = true

    let playerName = "Test Player"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                if isLoading {
                    ProgressView("Loading Stats...")
                } else if let stats = stats {
                    VStack(spacing: 16) {
                        StatRow(title: "Total Games", value: stats.total_games)
                        StatRow(title: "Wins", value: stats.wins)
                        StatRow(title: "Losses", value: stats.losses)
                        StatRow(title: "Win %", value: winPercentage(stats: stats))
                        StatRow(title: "Avg Guesses", value: String(format: "%.2f", stats.avg_guesses))
                    }
                    .padding()
                } else {
                    Text("No stats found.")
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .navigationTitle("My Stats")
            .task {
                await loadStats()
            }
        }
    }

    func loadStats() async {
        isLoading = true
        do {
            stats = try await SupabaseManager.shared.fetchStats(playerName: "Test Player")
        } catch {
            print("Failed to fetch stats:", error.localizedDescription)
        }
        isLoading = false
    }

    func winPercentage(stats: PlayerStats) -> String {
        guard stats.total_games > 0 else { return "0%" }
        let percent = Double(stats.wins) / Double(stats.total_games) * 100
        return String(format: "%.0f%%", percent)
    }
}
