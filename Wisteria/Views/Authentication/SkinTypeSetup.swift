//
//  SkinType.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI
import FirebaseAuth

struct SkinTypeSetup: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigateToHome: Bool
    
    @State private var selectedType: String? = nil
    @State private var isLoading = false
    @State private var navigateToNext = false
    
    let skinTypes = ["Oily", "Dry", "Combination", "Sensitive", "Normal"]
    
    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.92, blue: 0.89).ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(red: 0.38, green: 0.31, blue: 0.37))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 2).fill(Color(red: 0.32, green: 0.24, blue: 0.28)).frame(height: 4)
                    RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.2)).frame(height: 4)
                    RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.2)).frame(height: 4)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What best describes your skin?")
                            .font(.custom("Lustria-Regular", size: 30))
                        Text("Select your primary skin type")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(skinTypes, id: \.self) { type in
                            Button(action: {
                                let generator = UISelectionFeedbackGenerator()
                                generator.selectionChanged()
                                selectedType = type
                            }) {
                                Text(type)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 90)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedType == type ? Color(red: 0.32, green: 0.24, blue: 0.28) : Color.gray.opacity(0.2), lineWidth: 2)
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                    
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
                                .background(selectedType != nil ? Color(red: 0.32, green: 0.24, blue: 0.28) : Color(red: 0.81, green: 0.74, blue: 0.84))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .disabled(selectedType == nil || isLoading)
                    .padding(.horizontal, 20)
                    .animation(.easeInOut, value: selectedType)
                    
                    // FIXED: Removed the duplicate navigation destination that was here!
                }
                .padding(30)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        // Only one clean destination command
        .navigationDestination(isPresented: $navigateToNext) {
            SkinConcernSetup(navigateToHome: $navigateToHome)
        }
    }
    
    // MARK: - Logic
    func handleContinue() {
        guard let uid = Auth.auth().currentUser?.uid, let type = selectedType else { return }
        
        isLoading = true
        Task {
            do {
                try await UserService.shared.updateUserProfile(uid: uid, data: ["skinType": type])
                await MainActor.run {
                    isLoading = false
                    navigateToNext = true
                }
            } catch {
                await MainActor.run { isLoading = false }
            }
        }
    }
}
