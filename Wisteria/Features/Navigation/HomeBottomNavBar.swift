//
//  HomeBottomNavBar.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 25/01/2026.
//

import SwiftUI

struct HomeBottomNavBar: View {
    // This tracks which tab is currently active
    @Binding var selectedTab: Int
    
    // Brand Colors
    private let activePurple = Color(red: 0.88, green: 0.82, blue: 0.92)
    private let iconGray = Color.gray
    private let iconActive = Color(red: 0.32, green: 0.24, blue: 0.28)

    var body: some View {
        HStack {
            navButton(icon: "homePageIcon", index: 0)
            Spacer()
            navButton(icon: "chatPageIcon", index: 1)
            Spacer()
            navButton(icon: "diaryPageIcon", index: 2)
            
            Spacer()
            navButton(icon: "communityPageIcon", index: 3)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.95))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 25)
    }
    
    // Helper function to create the "Light Purple" background effect
    private func navButton(icon: String, index: Int) -> some View {
        Button(action: { selectedTab = index }) {
            ZStack {
                // The "Hidden Field" that appears when active
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(activePurple)
                        .frame(width: 45, height: 45)
                } else {
                    // Transparent box to keep spacing consistent
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.clear)
                        .frame(width: 45, height: 45)
                }
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    // Optional: tint the icon if it's a template image
                    // .foregroundColor(selectedTab == index ? iconActive : iconGray)
            }
        }
    }
}
