//
//  RecommendationChatView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import SwiftUI

struct RecommendationChatView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Product Recommendations")
                .font(.title2).bold()

            Text("Chat UI goes here (placeholder).")
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Recommendations")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    RecommendationChatView()
}