//
//  HomeBottomNavBar.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 25/01/2026.
//

import SwiftUI

struct HomeBottomNavBar: View {
    @Binding var selectedTab: Int
    
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
            navButton(icon: "communityPageIcon", index: 4)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.95))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 25)
    }
    
    private func navButton(icon: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            ZStack {
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(activePurple)
                        .frame(width: 50, height: 50)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.clear)
                        .frame(width: 50, height: 50)
                }
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

