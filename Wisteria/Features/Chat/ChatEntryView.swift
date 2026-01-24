//
//  ChatView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//
import SwiftUI

struct ChatEntryView: View {
    var body: some View {
        ZStack {
            // Background (soft, chic)
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.94, blue: 0.93),
                    Color(red: 0.90, green: 0.88, blue: 0.87)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                Spacer().frame(height: 24)

                Text("Wisteria Chat")
                    .font(.custom("PlayfairDisplay-Regular", size: 34))
                    .foregroundColor(.black)

                Text("Choose what you want help with today.")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.65))

                VStack(spacing: 14) {
                    NavigationLink {
                        RecommendationChatView()
                    } label: {
                        modeCard(
                            title: "Product recommendations",
                            subtitle: "Ask for makeup suggestions based on your skin profile."
                        )
                    }

                    NavigationLink {
                        IngredientAnalysisChatView()
                    } label: {
                        modeCard(
                            title: "Ingredient analysis",
                            subtitle: "Type a product name and get a safety breakdown."
                        )
                    }
                }
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal, 22)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func modeCard(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.6))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
