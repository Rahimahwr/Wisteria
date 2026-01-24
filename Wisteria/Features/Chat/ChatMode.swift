//
//  ChatMode.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import Foundation

enum ChatMode: String, CaseIterable, Identifiable {
    case recommendation = "Product Recommendations"
    case ingredientAnalysis = "Ingredient Analysis"

    var id: String { rawValue }
}
