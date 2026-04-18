//
//  ProfileSetup.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//
import SwiftUI
import FirebaseAuth

struct ProfileSetup: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigateToHome: Bool
    
    // Logic States
    @State private var isLoading = false
    @State private var navigateToSkinType = false // New trigger for next screen
    
    // Form States
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var retypePassword = ""
    @State private var securityAnswer = ""
    @State private var agreeToTerms = false
    @State private var selectedQuestion = "Security question"
    
    let securityQuestions = [
        "What was the name of your first pet?",
        "What is your mother's maiden name?",
        "In what city were you born?"
    ]
    
    private var isSignUpComplete: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        password.count >= 6 &&
        password == retypePassword &&
        selectedQuestion != "Security question" &&
        !securityAnswer.isEmpty &&
        agreeToTerms
    }
    
    var body: some View {
        AppBackground {
            VStack(spacing: 0) {
                Text("Create Your\nAccount")
                    .font(.custom("Lustria-Regular", size: 40))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                
                VStack(spacing: 16) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            customTextField(image: "person", placeholder: "Full Name", text: $fullName)
                            customTextField(image: "envelope", placeholder: "Email Address", text: $email)
                            customSecureField(image: "lock", placeholder: "Password", text: $password).textContentType(.newPassword)
                            customSecureField(image: "lock", placeholder: "Retype Password", text: $retypePassword).textContentType(.newPassword)
                            
                            securityQuestionMenu
                            
                            customTextField(image: "lock", placeholder: "Security answer", text: $securityAnswer)
                            
                            Toggle(isOn: $agreeToTerms) {
                                Text("I agree to the Terms & Privacy")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                            .toggleStyle(CheckboxStyle())
                            
                            // SIGN UP BUTTON
                            Button(action: handleSignUp) {
                                if isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Create Account")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                            .disabled(!isSignUpComplete || isLoading)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isSignUpComplete ? Color(red: 0.32, green: 0.24, blue: 0.28) : .gray)
                            .cornerRadius(30)
                            
                            Button(action: { dismiss() }) {
                                Text("Have an account? Sign In")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 30)
                    }
                }
                .padding(.horizontal, 25)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationDestination(isPresented: $navigateToSkinType) {
                SkinTypeSetup(navigateToHome: $navigateToHome)
            }
        }
        .navigationBarHidden(true)
        // This triggers the transition to the next setup phase after DB save is successful
    }
    
    // MARK: - Logic
    
    func handleSignUp() {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            // ... error handling ...
            guard let uid = result?.user.uid else { return }
            
            let newUser = UserProfile(
                uid: uid,
                fullName: fullName,
                email: email,
                securityQuestion: selectedQuestion,
                securityAnswer: securityAnswer,
                setupComplete: false // Important!
            )
            
            Task {
                do {
                    // 1. Save to Database
                    try await UserService.shared.saveUserProfile(newUser)
                    
                    await MainActor.run {
                        isLoading = false
                        // 2. Move to the next screen! (ContentView will now allow this)
                        self.navigateToSkinType = true
                    }
                } catch {
                    await MainActor.run { isLoading = false }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var securityQuestionMenu: some View {
        Menu {
            ForEach(securityQuestions, id: \.self) { question in
                Button(question) { selectedQuestion = question }
            }
        } label: {
            HStack {
                Image(systemName: "lock").foregroundColor(.gray)
                Text(selectedQuestion)
                    .foregroundColor(selectedQuestion == "Security question" ? .gray : .black)
                Spacer()
                Image(systemName: "triangle.fill")
                    .resizable()
                    .frame(width: 10, height: 8)
                    .rotationEffect(.degrees(180))
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(red: 0.93, green: 0.92, blue: 0.91))
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.purple.opacity(0.2), lineWidth: 1))
        }
    }
    
    func customTextField(image: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: image).foregroundColor(.gray)
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding()
        .background(Color(red: 0.93, green: 0.92, blue: 0.91))
        .cornerRadius(30)
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.purple.opacity(0.2), lineWidth: 1))
    }
    
    func customSecureField(image: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: image).foregroundColor(.gray)
            SecureField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding()
        .background(Color(red: 0.93, green: 0.92, blue: 0.91))
        .cornerRadius(30)
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.purple.opacity(0.2), lineWidth: 1))
    }
}

#Preview {
    ProfileSetup(navigateToHome: .constant(false))
}
