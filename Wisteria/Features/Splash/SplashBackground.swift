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
        ZStack(alignment: .top) {
            // Full-screen soft beige gradient
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.94, blue: 0.93),
                    Color(red: 0.90, green: 0.88, blue: 0.87)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Title + Subtitle pinned to top
            VStack(spacing: 12) {
                Text("Wisteria")
                    .font(.custom("PlayfairDisplay-Regular", size: 56))
                    .foregroundColor(.white)
                    .shadow(radius: 12)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeOut(duration: 1.2), value: fadeIn)

                Text("Personalised beauty, made gentle.")
                    .font(.system(size: 17, weight: .light))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeOut(duration: 1.5), value: fadeIn)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 60) // adjust for safe area + desired spacing
            .padding(.horizontal, 24)
        }
        .onAppear {
            fadeIn = true
        }
    }
}
