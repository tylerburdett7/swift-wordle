//
//  KeyboardKey.swift
//  WordleApp
//
//  Created by Tyler Burdett on 10/15/25.
//

import SwiftUI

struct KeyboardKey: Identifiable, Hashable {
    let id = UUID()
    let letter: String
    var state: LetterResult = .unknown
}

