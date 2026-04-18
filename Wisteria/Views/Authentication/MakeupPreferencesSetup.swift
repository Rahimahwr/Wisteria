//
//  MakeupPreferences.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//
import SwiftUI
import FirebaseAuth

struct MakeupPreferencesSetup: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigateToHome: Bool
    
    @State private var selectedCoverage: String? = nil
    @State private var selectedFinish: String? = nil
    @State private var selectedProducts: Set<String> = []
    @State private var isLoading = false
    
    let coverageLevels = ["Light", "Medium", "Full"]
    let finishes = ["Matte", "Dewy", "Natural"]
    let products = ["Foundation", "Concealer", "Blush", "Bronzer", "Primer", "Powder"]
    
    private let plumColor = Color(red: 0.32, green: 0.24, blue: 0.28)
    private let lightGrey = Color.gray.opacity(0.2)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .foregroundColor(plumColor)
                }
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            
            HStack(spacing: 8) {
                Rectangle().fill(plumColor).frame(height: 4)
                Rectangle().fill(plumColor).frame(height: 4)
                Rectangle().fill(plumColor).frame(height: 4)
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your makeup preferences")
                            .font(.custom("Lustria-Regular", size: 32))
                            .foregroundColor(.black)
                        Text("Help us personalise your experience")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    preferenceSection(title: "Coverage level", items: coverageLevels, selectionType: .singleCoverage)
                    preferenceSection(title: "Finish", items: finishes, selectionType: .singleFinish)
                    preferenceSection(title: "Products you use", items: products, selectionType: .multiProduct)
                    
                    Spacer(minLength: 30)
                    
                    Button(action: {
                        handleFinish()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(canFinish ? plumColor : Color(red: 0.81, green: 0.74, blue: 0.84))
                                .frame(height: 60)
                            
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Finish setup")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(!canFinish || isLoading)
                }
                .padding(30)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding(.top, 20)
            .ignoresSafeArea(edges: .bottom)
        }
        .background(Color(red: 0.95, green: 0.94, blue: 0.92))
        .navigationBarHidden(true)
    }
    
    private var canFinish: Bool {
        selectedCoverage != nil && selectedFinish != nil && !selectedProducts.isEmpty
    }
    
    // MARK: - Logic
    // In MakeupPreferencesSetup.swift

    func handleFinish() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        Task {
            do {
                let updateData: [String: Any] = [
                    "coverage": selectedCoverage ?? "",
                    "finish": selectedFinish ?? "",
                    "preferredProducts": Array(selectedProducts),
                    "setupComplete": true // Now the profile is officially finished
                ]
                
                try await UserService.shared.updateUserProfile(uid: uid, data: updateData)
                
                await MainActor.run {
                    isLoading = false
                    // This one line handles BOTH closing the reset pop-up
                    // AND completing the new user signup flow!
                    navigateToHome = true
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    func preferenceSection(title: String, items: [String], selectionType: SelectionType) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(items, id: \.self) { item in
                    let isSelected: Bool = {
                        switch selectionType {
                        case .singleCoverage: return selectedCoverage == item
                        case .singleFinish: return selectedFinish == item
                        case .multiProduct: return selectedProducts.contains(item)
                        }
                    }()
                    
                    selectionButton(item: item, isSelected: isSelected) {
                        switch selectionType {
                        case .singleCoverage: selectedCoverage = item
                        case .singleFinish: selectedFinish = item
                        case .multiProduct:
                            if selectedProducts.contains(item) { selectedProducts.remove(item) }
                            else { selectedProducts.insert(item) }
                        }
                    }
                }
            }
        }
    }
    
    func selectionButton(item: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(item)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? plumColor : lightGrey, lineWidth: isSelected ? 2 : 1)
                )
        }
    }
    
    enum SelectionType {
        case singleCoverage, singleFinish, multiProduct
    }
}
