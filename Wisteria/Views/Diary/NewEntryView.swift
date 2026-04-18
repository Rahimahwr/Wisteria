//
//  Untitled.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: () -> Void
    
    @State private var selectedMood = "Great"
    @State private var selectedConditions: Set<String> = []
    @State private var productText = ""
    
    let moods = ["Great", "Okay", "Breaking Out"]
    let conditions = ["Redness", "Dryness", "Oiliness", "Breakout", "Sensitivity", "None"]
   
    var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    
    var body: some View {
        //NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.93, blue: 0.95).ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("New Entry")
                        .font(.custom("Lustria-Regular", size: 28))
                    
                    Text("How's your skin feeling today?")
                    HStack {
                        ForEach(moods, id: \.self) { mood in
                            Button(mood) { selectedMood = mood }
                                .padding(.vertical, 12).frame(maxWidth: .infinity)
                                .background(selectedMood == mood ? Color.white : Color.clear)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: selectedMood == mood ? .bold : .regular))
                        }
                    }
                    
                    Text("Which skin conditions have you faced today?")
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                        ForEach(conditions, id: \.self) { condition in
                            Button(condition) {
                                if selectedConditions.contains(condition) {
                                    selectedConditions.remove(condition)
                                } else {
                                    selectedConditions.insert(condition)
                                }
                            }
                            .padding().frame(maxWidth: .infinity)
                            .background(selectedConditions.contains(condition) ? Color.white : Color.clear)
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.2)))
                            .foregroundColor(.black)
                        }
                    }
                    
                    Text("Products Used")
                    TextField("e.g. L'oreal Foundation", text: $productText)
                        .padding().background(Color.gray.opacity(0.1)).cornerRadius(15)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            // 1. Disable the button immediately so user can't tap twice
                            Task {
                                do {
                                    try await DiaryService.shared.saveEntry(
                                        mood: selectedMood,
                                        conditions: Array(selectedConditions),
                                        products: productText
                                    )
                                    
                                    // 2. Wrap the UI changes in a small delay or MainActor
                                    await MainActor.run {
                                        onSave()
                                        // Adding a tiny delay helps the AttributeGraph breathe
                                        // before the animation starts
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            dismiss()
                                        }
                                    }
                                } catch {
                                    print("Save failed: \(error)")
                                    await MainActor.run { dismiss() }
                                }
                            }
                        }) {
                            Text("Save entry")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.3, green: 0.2, blue: 0.25))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        
                        .padding().frame(maxWidth: .infinity)
                        .background(Color(red: 0.3, green: 0.2, blue: 0.25)).foregroundColor(.white).cornerRadius(15)
                        
                        Button("Cancel") { dismiss() }
                        .padding().frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.4)).foregroundColor(.black).cornerRadius(15)
                    }
                }
                .padding(25)
            }
        //}
    }
}

