//
//  SkinConcernSetup.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 25/01/2026.
//

import SwiftUI
import FirebaseAuth

struct SkinConcernSetup: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigateToHome: Bool
    
    // Fixed: Added missing State variables
    @State private var selectedConcerns: Set<String> = []
    @State private var isLoading = false
    @State private var navigateToNext = false
    
    let concerns = [
        "Acne-prone", "Rosacea",
        "Eczema", "Hyperpigmentation",
        "Allergies", "Fragrance sensitivity"
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .foregroundColor(Color(red: 0.32, green: 0.24, blue: 0.28))
                }
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            
            // Progress Bar
            HStack(spacing: 8) {
                Rectangle().fill(Color(red: 0.32, green: 0.24, blue: 0.28)).frame(height: 4)
                Rectangle().fill(Color(red: 0.32, green: 0.24, blue: 0.28)).frame(height: 4)
                Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 4)
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            ScrollView { // Added ScrollView in case concerns list grows
                VStack(alignment: .leading, spacing: 10) {
                    Text("What are your skin concerns?")
                        .font(.custom("Lustria-Regular", size: 32))
                        .foregroundColor(.black)
                    
                    Text("Select all that apply")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(concerns, id: \.self) { concern in
                            ConcernOptionCard(
                                title: concern,
                                isSelected: selectedConcerns.contains(concern)
                            ) {
                                if selectedConcerns.contains(concern) {
                                    selectedConcerns.remove(concern)
                                } else {
                                    selectedConcerns.insert(concern)
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 30)
                    
                    Button(action: {
                        handleContinue()
                    }) {
                        if isLoading {
                            ProgressView().tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color(red: 0.32, green: 0.24, blue: 0.28))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(selectedConcerns.isEmpty ? Color(red: 0.81, green: 0.74, blue: 0.84) : Color(red: 0.32, green: 0.24, blue: 0.28))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .disabled(selectedConcerns.isEmpty || isLoading)
                }
                .padding(30)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding(.top, 30)
            .ignoresSafeArea(edges: .bottom)
        }
        .background(Color(red: 0.95, green: 0.94, blue: 0.92))
        .navigationBarHidden(true)
        // Fixed: Added Navigation Destination
        .navigationDestination(isPresented: $navigateToNext) {
            MakeupPreferencesSetup(navigateToHome: $navigateToHome)
        }
    }
    
    // Fixed: Moved inside the struct and updated logic for Concerns
    func handleContinue() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        Task {
            do {
                // Fixed: Saving an array of concerns instead of skinType
                let dataToSave = ["skinConcerns": Array(selectedConcerns)]
                try await UserService.shared.updateUserProfile(uid: uid, data: dataToSave)
                
                await MainActor.run {
                    isLoading = false
                    navigateToNext = true
                }
            } catch {
                print("Error saving concerns: \(error.localizedDescription)")
                await MainActor.run { isLoading = false }
            }
        }
    }
}

// Separate View for the Card
struct ConcernOptionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color(red: 0.32, green: 0.24, blue: 0.28) : Color(red: 0.9, green: 0.88, blue: 0.85), lineWidth: isSelected ? 2 : 1)
                )
        }
    }
}
