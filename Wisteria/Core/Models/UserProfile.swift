//
//  UserProfile.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 27/03/2026.
//


import Foundation
import FirebaseFirestore

struct UserProfile: Codable , Sendable{
    var uid: String
    var fullName: String
    var email: String
    var securityQuestion: String
    var securityAnswer: String
    
    // Skin Profile Data
    var skinType: String?
    var skinConcerns: [String] = []
    
    // Makeup Preferences
    var coverage: String?
    var finish: String?
    var preferredProducts: [String]?
    
    var setupComplete: Bool = false
}
