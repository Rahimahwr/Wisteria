//
//  LoginView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

struct LoginView: View {
    @Binding var navigateToHome: Bool
    @Binding var navigateToProfileSetup: Bool
    @Binding var navigateToForgotPassword: Bool

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Log in")
                    .font(.custom("PlayfairDisplay-Regular", size: 34))
                    .foregroundColor(.black)

                VStack(spacing: 16) {
                    TextField("Email address", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.gray.opacity(0.25))
                        )

                    SecureField("Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.gray.opacity(0.25))
                        )
                }

                Button {
                    navigateToHome = true
                } label: {
                    Text("Continue")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.25, green: 0.19, blue: 0.22))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                .padding(.top, 4)

                Button {
                    navigateToForgotPassword = true
                } label: {
                    Text("Forgot password?")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity)
                }

                Button {
                    navigateToProfileSetup = true
                } label: {
                    Text("Create an account")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color(red: 0.97, green: 0.95, blue: 0.93))
    }
}
