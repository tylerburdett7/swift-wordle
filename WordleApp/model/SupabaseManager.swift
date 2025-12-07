//
//  SupabaseManager.swift
//  WordleApp
//
//  Created by Tyler Burdett on 11/1/25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    private init() {}
    
    private let supabaseUrl = URL(string: "https://tnzrcvnemqvbamsiaove.supabase.co")!
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRuenJjdm5lbXF2YmFtc2lhb3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwMjExNjMsImV4cCI6MjA3NzU5NzE2M30.xLGFQCOPrlb2ku6G2SHfIHz675ge8p8WLS3plF_taMk"
    
    lazy var client = SupabaseClient(
        supabaseURL: supabaseUrl,
        supabaseKey: supabaseKey
    )
    
    // MARK: - Fetch Player Stats
    func fetchStats(playerName: String) async throws -> PlayerStats {
        let result = try await client
            .from("player_stats")
            .select()
            .eq("player_name", value: playerName)
            .single()
            .execute()
        
        return try JSONDecoder().decode(PlayerStats.self, from: result.data)
    }
    
    // MARK: - Update Stats
    func updateStats(playerName: String, won: Bool, guesses: Int) async {
        do {
            var stats = try await fetchStats(playerName: playerName)
            
            stats.total_games += 1
            if won { stats.wins += 1 } else { stats.losses += 1 }
            
            stats.avg_guesses =
                ((stats.avg_guesses * Double(stats.total_games - 1)) + Double(guesses))
                / Double(stats.total_games)
            
            try await client
                .from("player_stats")
                .update(stats)
                .eq("player_name", value: playerName)
                .execute()
            
            print("✅ Stats updated")
            
        } catch {
            print("❌ Failed to update stats:", error.localizedDescription)
        }
    }
}

