//
//  MainTabView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 25/01/2026.
//

import Foundation
import SwiftUI
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Group {
                if selectedTab == 0 {
                    NavigationStack {
                        HomeView(selectedTab: $selectedTab)
                    }
                } else if selectedTab == 1 {
                    NavigationStack {
                        ChatEntryView()
                    }
                } else if selectedTab == 2 {
                    NavigationStack {
                        SkinDiaryView()
                                            }
                } else if selectedTab == 3 {
                    NavigationStack {
                        CollectionEntryView()
                    }
                } else {
                    NavigationStack {
                        CommunityView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HomeBottomNavBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
                .zIndex(1)
        }
    }
}
