//
//  SplashBackground.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//


import SwiftUI

struct SplashBackground: View {
    @State private var fadeIn = false

    var body: some View {
        AppBackground {
          
            VStack(spacing: 8) {
                Text("Wisteria")
                    
                    .font(.custom("Lustria-Regular", size: 60))
                    .foregroundColor(Color(red: 0.38, green: 0.31, blue: 0.37))
                    .opacity(fadeIn ? 1 : 0)
                
                Text("Personalised beauty")
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .foregroundColor(Color(red: 0.38, green: 0.31, blue: 0.37).opacity(0.8))
                    .opacity(fadeIn ? 1 : 0)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    fadeIn = true
                }
            }
        }
    }
}

#Preview {
    SplashBackground()
}
