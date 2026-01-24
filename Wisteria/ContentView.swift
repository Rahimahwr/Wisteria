//
//  ContentView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoginView: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var navigateToProfileSetup: Bool = false
    @State private var navigateToForgotPasswordView: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                SplashBackground()

                Color.clear.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeIn(duration: 0.25)) {
                            showLoginView = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showLoginView) {
                LoginView(
                    navigateToHome: $navigateToHome,
                    navigateToProfileSetup: $navigateToProfileSetup,
                    navigateToForgotPassword: $navigateToForgotPasswordView
                )
                .presentationDetents([.medium])
                .presentationCornerRadius(36)
                .presentationDragIndicator(.hidden)
            }
            // Navigation destinations
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
            .navigationDestination(isPresented: $navigateToProfileSetup) {
                ProfileSetup()
            }
            .navigationDestination(isPresented: $navigateToForgotPasswordView) {
                ForgotPasswordView()
            }

            // FIX: Automatically dismiss login sheet when navigating
            .onChange(of: navigateToHome) { _, _ in
                showLoginView = false
            }
            .onChange(of: navigateToProfileSetup) { _, _ in
                showLoginView = false
            }
            .onChange(of: navigateToForgotPasswordView) { _, _ in
                showLoginView = false
            }

        }
    }
}

#Preview{
    ContentView()
}
