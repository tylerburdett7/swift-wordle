//
//  SupabaseManager.swift
//  WordleApp
//
//  Created by Tyler Burdett on 11/1/25.
//

import Foundation
import Supabase

// MARK: - Codable struct for stats
struct PlayerStats: Codable {
    var player_name: String
    var wins: Int
    var losses: Int
    var avg_guesses: Double
    var total_games: Int
}

class SupabaseManager {
    static let shared = SupabaseManager()
    private init() {}
    
    private let supabaseUrl = URL(string: "https://tnzrcvnemqvbamsiaove.supabase.co")!
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRuenJjdm5lbXF2YmFtc2lhb3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwMjExNjMsImV4cCI6MjA3NzU5NzE2M30.xLGFQCOPrlb2ku6G2SHfIHz675ge8p8WLS3plF_taMk"
    
    lazy var client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    
    // MARK: - Create a test player
    func addTestPlayer() async {
        let testPlayer = PlayerStats(
            player_name: "TestPlayer",
            wins: 0,
            losses: 0,
            avg_guesses: 0.0,
            total_games: 0
        )
        
        do {
            let response = try await client
                .from("player_stats")
                .insert(testPlayer)
                .execute()
            print("✅ Insert successful: \(response)")
        } catch {
            print("❌ Error inserting player: \(error)")
        }
    }
    
    // MARK: - Update player stats
    func updateStats(playerName: String, won: Bool, guesses: Int) async {
        do {
            // Fetch the player's current stats
            let result = try await client
                .from("player_stats")
                .select()
                .eq("player_name", value: playerName)
                .single()
                .execute()
            
            let data = result.data

            // Decode JSON to PlayerStats
            var stats = try JSONDecoder().decode(PlayerStats.self, from: data)

            
            // Update stats
            stats.total_games += 1
            if won { stats.wins += 1 } else { stats.losses += 1 }
            stats.avg_guesses = ((stats.avg_guesses * Double(stats.total_games - 1)) + Double(guesses)) / Double(stats.total_games)
            
            // Push updated stats
            let updateResponse = try await client
                .from("player_stats")
                .update(stats)
                .eq("player_name", value: playerName)
                .execute()
            
            print("✅ Stats updated successfully: \(updateResponse)")
            
        } catch {
            print("❌ Failed to update stats: \(error)")
        }
    }
}
