//
//  HomeView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//
import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var selectedTab: Int
    @StateObject private var viewModel = HomeViewModel()
    @State private var showNewEntryView = false
    @State private var navigateToReset = false
    
    private let plumPrimary = Color(red: 0.32, green: 0.24, blue: 0.28)
    private let lavenderCard = Color(red: 0.81, green: 0.74, blue: 0.84).opacity(0.4)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Background
            Image("backgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // 2. Main Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Header Section
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Hello, \(viewModel.currentUser?.fullName.components(separatedBy: " ").first ?? "User")")
                                .font(.custom("Lustria-Regular", size: 34))
                                .foregroundColor(.black)
                            
                            Text("Last log: \(viewModel.lastLogDate)")
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        Spacer()
                        topMenu
                    }
                    .padding(.top, 50)
                    
                    // Skin Profile Summary Box
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Your Skin Profile")
                            .font(.custom("Lustria-Regular", size: 20))
                        
                        HStack(spacing: 12) {
                            InfoBox(label: "Skin Type", value: viewModel.currentUser?.skinType ?? "Loading...")
                            InfoBox(label: "Main Concern", value: viewModel.currentUser?.skinConcerns.first ?? "None set")
                        }
                    }
                    .padding()
                    .background(lavenderCard)
                    .cornerRadius(25)
                    
                    // "Log Today" Action Button
                    Button(action: { showNewEntryView = true }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Log Today")
                                    .font(.headline)
                                Text("How is your skin feeling?")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                        .foregroundColor(.black)
                    }

                    // Recent Entries List (Shows last 3)
                    /*if !viewModel.entries.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Recent Progress")
                                .font(.custom("Lustria-Regular", size: 20))
                            
                            ForEach(viewModel.entries.prefix(3)) { entry in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(entry.dateString).bold()
                                        Text(entry.conditions.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text(entry.statusLabel)
                                        .font(.caption).bold()
                                        .padding(.horizontal, 12).padding(.vertical, 5)
                                        .background(entry.statusLabel == "Good" ? plumPrimary : Color.black.opacity(0.6))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(15)
                            }
                        }
                    }
                    */

                    // Main App Navigation Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                        actionButton(tab: 1, icon: "chatPageIcon", title: "AI Chat", sub: "Personalised advice")
                        actionButton(tab: 3, icon: "collectionPageIcon", title: "Collection", sub: "Saved products")
                        actionButton(tab: 2, icon: "diaryPageIcon", title: "Skin Diary", sub: "Track progress")
                        actionButton(tab: 4, icon: "communityPageIcon", title: "Community", sub: "Connect & Share")
                    }
                    
                    Spacer(minLength: 140) // Space for bottom nav
                }
                .padding(.horizontal, 25)
            }
            .ignoresSafeArea(.container, edges: .bottom)
            
            // 3. Persistent Bottom Nav (Optional if MainTabView handles this)
            HomeBottomNavBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.refreshData()
            viewModel.fetchCurrentUserData()
        }
        // Sheets & Covers
        .sheet(isPresented: $showNewEntryView) {
            NewEntryView {
                viewModel.refreshData()
            }
        }
        .fullScreenCover(isPresented: $navigateToReset, onDismiss: {
            viewModel.fetchCurrentUserData()
        }) {
            NavigationStack {
                SkinTypeSetup(navigateToHome: Binding(
                    get: { false },
                    set: { _ in navigateToReset = false }
                ))
            }
        }
    }
    
    // MARK: - Components
    
    private var topMenu: some View {
        Menu {
            Button(action: { navigateToReset = true }) {
                Label("Reset Skin Profile", systemImage: "arrow.counterclockwise")
            }
            Button(role: .destructive, action: { handleLogout() }) {
                Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.title2)
                .foregroundColor(.black)
                .padding(10)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())
        }
    }
    
    private func handleLogout() {
        try? Auth.auth().signOut()
    }
    
    func actionButton(tab: Int, icon: String, title: String, sub: String) -> some View {
        Button(action: { selectedTab = tab }) {
            ActionCard(icon: icon, title: title, sub: sub)
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
