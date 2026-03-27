//
//  ProfileSetup.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

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
        VStack(alignment: .leading, spacing: 24) {

            Text("Create Your Skin Profile")
                .font(.custom("PlayfairDisplay-Regular", size: 32))

            Text("Help us personalise your makeup routine.")
                .font(.system(size: 15))
                .foregroundColor(.gray)

            NavigationLink("Start") {
                SkinTypeSetup()   // correct naming
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Spacer()
        }
        .padding()
        .navigationTitle("Setup")
    }
}
