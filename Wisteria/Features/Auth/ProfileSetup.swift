//
//  ProfileSetup.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

struct ProfileSetup: View {
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
