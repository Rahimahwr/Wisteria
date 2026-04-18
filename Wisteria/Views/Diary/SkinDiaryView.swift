//
//  SkinDiaryView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import SwiftUI

struct SkinDiaryView: View {
    @State private var showNewEntry = false
    @State private var entries: [DiaryEntry] = []
    @State private var weeklyStats: [String: Int] = ["Great": 0, "Okay": 0, "Breaking Out": 0]

    private let plumPrimary = Color(red: 0.3, green: 0.2, blue: 0.25)
        
    var body: some View {
        ZStack {
            Image("backgroundImage")
                .resizable()
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    headerSection
                    
                    // FIXED: This was missing from the layout!
                    progressSection
                    
                    recentEntriesSection
                    
                    Color.clear.frame(height: 150)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            print("📱 SkinDiaryView Appeared")
            fetchDiaryData()
        }
        .sheet(isPresented: $showNewEntry) {
            NewEntryView {
                print("🔄 Refreshing after save...")
                fetchDiaryData()
            }
        }
    }
        
    private func fetchDiaryData() {
        Task {
            do {
                let fetched = try await DiaryService.shared.fetchEntries()
                
                await MainActor.run {
                    self.entries = fetched
                    self.calculateStats(from: fetched)
                    print("✅ UI and Stats updated with \(fetched.count) entries")
                }
            } catch {
                print("❌ Error fetching diary: \(error)")
            }
        }
    }
    
    private func calculateStats(from allEntries: [DiaryEntry]) {
        var stats = ["Great": 0, "Okay": 0, "Breaking Out": 0]
        
        // Get the date for 7 days ago
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        // Filter entries from the last 7 days and count moods
        for entry in allEntries where entry.timestamp >= weekAgo {
            stats[entry.mood, default: 0] += 1
        }
        
        // Update the state variable
        self.weeklyStats = stats
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("This Week")
                .font(.headline)
            
            HStack(spacing: 15) {
                statBox(count: weeklyStats["Great"] ?? 0, label: "Great")
                statBox(count: weeklyStats["Breaking Out"] ?? 0, label: "Breaking Out")
                statBox(count: weeklyStats["Okay"] ?? 0, label: "Okay")
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.6)))
    }

    func statBox(count: Int, label: String) -> some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 24, weight: .bold))
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.purple.opacity(0.1)))
    }

    // Updated Recent Entries to include Products
    private var recentEntriesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Entries")
                .font(.system(size: 22, weight: .medium))
            
            if entries.isEmpty {
                Text("No entries found yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(entries) { entry in
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // Top Row: Date & Status Badge
                        HStack {
                            Text(entry.dateString).bold()
                            Spacer()
                            Text(entry.statusLabel)
                                .font(.caption).bold()
                                .padding(.horizontal, 15).padding(.vertical, 6)
                                .background(entry.statusLabel == "Good" ? plumPrimary : Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        
                        // Middle Row: Conditions
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current skin conditions:")
                                .font(.system(size: 14, weight: .medium))
                            Text(entry.conditions.joined(separator: ", "))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        // Bottom Row: Products
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Products used:")
                                .font(.system(size: 14, weight: .medium))
                            Text(entry.products.isEmpty ? "None listed" : entry.products)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                    }
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.8)))
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Skin Diary")
                .font(.custom("Lustria-Regular", size: 32))
            Spacer()
            Button(action: { showNewEntry = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(plumPrimary)
            }
        }
        .padding(.top, 20)
    }
}
