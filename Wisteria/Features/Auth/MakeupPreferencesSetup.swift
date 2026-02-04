//
//  MakeupPreferences.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

struct MakeupPreferencesSetup: View {
    @Environment(\.dismiss) var dismiss
    
    // State to track selections
    @State private var selectedCoverage: String? = nil
    @State private var selectedFinish: String? = nil
    @State private var selectedProducts: Set<String> = []
    
    // Data for the selections
    let coverageLevels = ["Light", "Medium", "Full"]
    let finishes = ["Matte", "Dewy", "Natural"]
    let products = ["Foundation", "Concealer", "Blush", "Bronzer", "Primer", "Powder"]
    
    // Colors
    private let plumColor = Color(red: 0.32, green: 0.24, blue: 0.28)
    private let lightGrey = Color.gray.opacity(0.2)
    
    var body: some View {
        Text("Makeup Preferences Setup (placeholder)")
            .navigationTitle("Preferences")
    }
}
