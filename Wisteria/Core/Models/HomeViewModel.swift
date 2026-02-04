//
//  HomeViewModel.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 25/01/2026.
//

import SwiftUI 
internal import Combine

class HomeViewModel: ObservableObject {
    @Published var currentUser: UserData
    
    init() {
      
        self.currentUser = UserData(
            name: "Rahimah",
            skinType: "Combination",
            mainConcern: "Acne-prone",
            lastEntryDate: "2 days ago"
        )
    }
}
