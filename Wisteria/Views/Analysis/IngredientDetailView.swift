//
//  IngredientDetailView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 02/02/2026.
//

import Foundation
import SwiftUI

struct IngredientDetailView: View {
    let analysis: ProductAnalysis
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 15) {
                    AsyncImage(url: URL(string: analysis.imageUrl))
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading) {
                        Text(analysis.name)
                            .font(.title2).bold()
                        Text(analysis.brand)
                            .foregroundColor(.secondary)
                        
                            //SafetyGauge(score: analysis.safetyRating)
                    }
                }
                .padding()
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Label("AI Analysis", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundColor(.purple)
                    
                    Text(analysis.aiSummary)
                        .font(.subheadline)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                
                VStack(alignment: .leading) {
                    Text("Ingredient Breakdown")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(analysis.ingredients) { ingredient in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(ingredient.name).bold()
                                Text(ingredient.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(ingredient.riskLevel.rawValue)
                                .font(.caption2).bold()
                                .padding(6)
                                .background(ingredient.riskLevel.color.opacity(0.2))
                                .foregroundColor(ingredient.riskLevel.color)
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Analysis")
    }
}
