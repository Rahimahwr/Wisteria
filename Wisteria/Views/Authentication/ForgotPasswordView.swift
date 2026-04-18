//
//  ForgotPasswordView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//
import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var resetSent = false
    
    // Feedback and styling variables
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoading = false
    
    // Define the Plum accent color used elsewhere in the app
    private let plumColor = Color(red: 0.32, green: 0.24, blue: 0.28)

    var body: some View {
        ZStack {
            // THEME: The new light cream background used in setup/home views
            Color(red: 0.95, green: 0.94, blue: 0.92).ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Centered, clean design matching screenshot
                VStack(spacing: 12) {
                    // Larger Lustria-Regular typography
                    Text("Forgot\nPassword?")
                        .font(.custom("Lustria-Regular", size: 40))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)

                    Text("Enter your email address and we'll send you a recovery link to access your account.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                .padding(.top, 20)

                // Clean input card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email address")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("your@email.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 25)

                if resetSent {
                    Text("A recovery link has been sent to \(email). Please check your inbox and your spam folder.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.purple.opacity(0.8)) // Matching theme color
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .transition(.opacity)
                }

                Spacer()

                // SEND BUTTON / PROGRESS VIEW
                Button(action: {
                    if !email.isEmpty && !isLoading {
                        sendFirebaseResetEmail()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(email.isEmpty ? Color.gray.opacity(0.3) : plumColor)
                            .frame(height: 60)
                        
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Send recovery link")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(email.isEmpty || isLoading)
                .padding(.horizontal, 25)
                .padding(.bottom, 20)

                // Back Button
                Button(action: { dismiss() }) {
                    Text("Back to login")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 30)

            }
            .padding(.horizontal, 10)
        }
        .navigationBarHidden(true)
        // Alert for backend errors
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Recovery Issue"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - Logic (BACKEND CONNECTION)
    
    private func sendFirebaseResetEmail() {
        isLoading = true
        resetSent = false // Reset feedback state
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            isLoading = false
            
            if let error = error {
                // Firebase technical codes mapped to professional messages
                let nsError = error as NSError
                switch nsError.code {
                case AuthErrorCode.userNotFound.rawValue:
                    self.errorMessage = "We couldn't find an account with that email address. Please verify your spelling or sign up."
                case AuthErrorCode.invalidEmail.rawValue:
                    self.errorMessage = "Please enter a valid email address."
                default:
                    self.errorMessage = "We couldn't send the recovery link. Please try again later."
                }
                self.showError = true
            } else {
                // Success!
                withAnimation(.easeInOut) {
                    resetSent = true
                }
            }
        }
    }
}


#Preview {
    ForgotPasswordView()
}
