//
//  ForgotPasswordView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

struct ForgotPasswordView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var resetSent = false

    var body: some View {
        VStack(spacing: 24) {

            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Reset Password")
                    .font(.custom("PlayfairDisplay-Regular", size: 32))
                    .foregroundColor(.black)

                Text("Enter your email and we’ll send you a reset link.")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40)

            // Email Field
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.3))
                )

            // Reset Button
            Button {
                // FRONT-END ONLY: Simulate sending reset link
                withAnimation {
                    resetSent = true
                }
            } label: {
                Text("Send Reset Link")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.top, 10)

            // Confirmation Message
            if resetSent {
                Text("A password reset link has been sent to your email.")
                    .font(.system(size: 14))
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                    .transition(.opacity)
            }

            Spacer()

            // Back button
            Button {
                dismiss()
            } label: {
                Text("Back to Login")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.bottom, 20)

        }
        .padding(.horizontal, 28)
        .navigationBarBackButtonHidden(true)
    }
}
