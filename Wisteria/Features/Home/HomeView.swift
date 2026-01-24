//
//  HomeView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 05/12/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome to Wisteria!")
                .font(.title)
                .padding(.top)

            Text("This is the temporary home screen.")
                .foregroundColor(.gray)
        }
        .navigationTitle("Home")
    }
}
