//
//  CollectionEntryView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 28/03/2026.
//

import SwiftUI

// This structure defines what is shown on a single card
struct ProductEntry: Identifiable {
    let id = UUID()
    let name: String
    let brand: String
    let safetyLabel: String // "Safe", "Caution", "Avoid"
    var isSaved: Bool
}

struct CollectionEntryView: View {
    @State private var searchText = ""
    @State private var selectedFilter = 0 // 0=All, 1=Safe, 2=Caution, 3=Avoid
    
    // Sample Data (Dummy list to fill the UI for now)
    @State private var products = [
        ProductEntry(name: "Glossier Perfecting Skin Tint", brand: "Glossier", safetyLabel: "Safe", isSaved: true),
        ProductEntry(name: "Glossier Perfecting Skin Tint", brand: "Glossier", safetyLabel: "Avoid", isSaved: false),
        ProductEntry(name: "Glossier Perfecting Skin Tint", brand: "Glossier", safetyLabel: "Safe", isSaved: true),
        ProductEntry(name: "Glossier Perfecting Skin Tint", brand: "Glossier", safetyLabel: "Safe", isSaved: true)
    ]
    
    // Theme and Styling Variables
    private let plumColor = Color(red: 0.32, green: 0.24, blue: 0.28)
    private let creamBackground = Color(red: 0.95, green: 0.94, blue: 0.92)
    private let lavenderAccent = Color(red: 0.81, green: 0.74, blue: 0.84)
    private let searchBackground = Color(red: 0.93, green: 0.92, blue: 0.91)
    private let labelBackground = Color(red: 0.81, green: 0.74, blue: 0.84).opacity(0.4)
    
    let filters = ["All", "Safe", "Caution", "Avoid"]

    var body: some View {
        ZStack {
            // THEME: The consistent light cream background
            creamBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // 1. HEADER (Title and search bar)
                VStack(alignment: .leading, spacing: 18) {
                    Text("Product Collection")
                        .font(.custom("Lustria-Regular", size: 34))
                        .foregroundColor(.black)
                        .padding(.top, 25)
                    
                    // The simple, clean search bar matching your text fields
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        
                        TextField("Search products...", text: $searchText)
                            .font(.system(size: 16))
                    }
                    .padding()
                    .background(searchBackground)
                    .cornerRadius(18)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20)

                // 2. FILTERS (ScrollView)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<filters.count, id: \.self) { index in
                            Button(action: {
                                selectedFilter = index
                            }) {
                                Text(filters[index])
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedFilter == index ? .white : .black)
                                    .padding(.horizontal, 22)
                                    .padding(.vertical, 12)
                                    .background(selectedFilter == index ? plumColor : Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedFilter == index ? plumColor : Color.gray.opacity(0.15), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 20)
                }
                
                // 3. PRODUCT LIST (ScrollView with cards)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(products) { product in
                            ProductCardView(product: product)
                                .onTapGesture {
                                    // Navigate to details (later)
                                }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    .padding(.bottom, 30) // Smooth scroll padding
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
    }
    
    // Subview for a single product card
    func ProductCardView(product: ProductEntry) -> some View {
        HStack(alignment: .top, spacing: 15) {
            // Placeholder/Data for product visual (later)
            Color.white
                .frame(width: 20, height: 20) // Dummy data marker
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.custom("Lustria-Regular", size: 18))
                    .foregroundColor(.black)
                
                Text(product.brand)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                // Safety Label (pill-shaped)
                Text(product.safetyLabel)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(labelBackground)
                    .clipShape(Capsule())
            }
            
            Spacer()
            
            // Save Icon (heart/bookmark matching image)
            Button(action: {
                // Backend save logic will go here later
                if let index = products.firstIndex(where: { $0.id == product.id }) {
                    products[index].isSaved.toggle()
                }
            }) {
                Image(systemName: product.isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 22))
                    .foregroundColor(product.isSaved ? plumColor : Color.black)
                    .padding(5)
            }
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(25)
    }
}

#Preview {
    CollectionEntryView()
}
