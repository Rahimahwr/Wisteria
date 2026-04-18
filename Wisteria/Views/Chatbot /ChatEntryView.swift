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
            Image("backgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How can Wisteria\nhelp today?")
                            .font(.custom("Lustria-Regular", size: 36))
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .lineSpacing(4)
                        
                        Text("Choose what you'd like help with")
                            .font(.system(size: 18))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(.top, 60)

                    VStack(spacing: 20) {
                        NavigationLink(destination: ChatView(mode: .recommendation)) {
                            modeCard(title: "Personalised Product Recommendations", subtitle: "Find products tailored to you")
                        }

                        NavigationLink(destination: ChatView(mode: .ingredientAnalysis)) {
                            modeCard(title: "Product Ingredient Analysis", subtitle: "Check if a product is safe for your skin")
                        }
                    }
                    
                    Spacer(minLength: 140)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func modeCard(title: String, subtitle: String) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.custom("Lustria-Regular", size: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.5))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray.opacity(0.4))
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.9)) 
        )
        .shadow(color: Color.black.opacity(0.03), radius: 15, x: 0, y: 10)
    }
}

#Preview {
    ChatEntryView()
}
