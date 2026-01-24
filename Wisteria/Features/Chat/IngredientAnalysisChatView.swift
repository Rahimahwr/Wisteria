//
//  IngredientAnalysisChatView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import SwiftUI

struct IngredientAnalysisChatView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Ingredient Analysis")
                .font(.title2).bold()

            Text("User will type a product name here (placeholder).")
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Ingredient Analysis")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    IngredientAnalysisChatView()
}