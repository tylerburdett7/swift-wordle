//
//  PlayerStats.swift
//  WordleApp
//
//  Created by Tyler Burdett on 12/3/25.
//

import Foundation

struct PlayerStats: Codable {
    var player_name: String
    var wins: Int
    var losses: Int
    var avg_guesses: Double
    var total_games: Int
}

