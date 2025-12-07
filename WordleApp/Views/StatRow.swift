//
//  StatRow.swift
//  WordleApp
//
//  Created by Tyler Burdett on 12/3/25.
//

import SwiftUI

struct StatRow: View {
    let title: String
    let value: Any

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)

            Spacer()

            Text("\(value)")
                .font(.title3)
                .bold()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
