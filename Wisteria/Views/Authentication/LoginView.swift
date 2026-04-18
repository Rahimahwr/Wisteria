//
//  LoginView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//
import SwiftUI
import FirebaseAuth // Necessary to handle the login logic

struct LoginView: View {
    @Binding var navigateToHome: Bool
    @Binding var navigateToProfileSetup: Bool
    @Binding var navigateToForgotPassword: Bool

    @State private var email = ""
    @State private var password = ""
    
    // Necessary for Firebase feedback
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoading = false

    private var isFormComplete: Bool {
        !email.isEmpty && password.count >= 6
    }

    private let activeColor = Color(red: 0.38, green: 0.31, blue: 0.37)
    private let disabledColor = Color(red: 0.81, green: 0.74, blue: 0.84)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {

                Text("Log in")
                    .font(.custom("Lustria-Regular", size: 34))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Email address")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.8))
                    
                    TextField("your@email.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(red: 0.92, green: 0.91, blue: 0.89))
                        .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.8))
                    
                    SecureField("**********", text: $password)
                        .padding()
                        .background(Color(red: 0.92, green: 0.91, blue: 0.89))
                        .cornerRadius(14)
                }

                Button {
                    if isFormComplete {
                        handleLogin()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(activeColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(isFormComplete ? activeColor : disabledColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .disabled(!isFormComplete || isLoading)
                .padding(.top, 10)
                .animation(.easeInOut(duration: 0.2), value: isFormComplete)

                VStack(spacing: 16) {
                    Button {
                        navigateToForgotPassword = true
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.6))
                    }

                    Button {
                        navigateToProfileSetup = true
                    } label: {
                        Text("Create an account")
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Login Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handleLogin() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error as NSError? {
                // Mapping Firebase technical codes to professional user messages
                switch error.code {
                case AuthErrorCode.userNotFound.rawValue:
                    self.errorMessage = "We couldn't find an account with that email. Please check your credentials or create a new account."
                case AuthErrorCode.wrongPassword.rawValue:
                    self.errorMessage = "The password entered is incorrect. Please try again."
                case AuthErrorCode.invalidEmail.rawValue:
                    self.errorMessage = "Please enter a valid email address."
                default:
                    self.errorMessage = "An unexpected error occurred. Please try again later."
                }
                self.showError = true
            } else {
                // Success: Trigger the transition to Home
                withAnimation {
                    self.navigateToHome = true
                }
            }
        }
    }

}

#Preview {
    LoginView(
        navigateToHome: .constant(false),
        navigateToProfileSetup: .constant(false),
        navigateToForgotPassword: .constant(false)
    )
}
