//
//  UserService.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 27/03/2026.
//


import FirebaseFirestore
import FirebaseAuth

@MainActor // This ensures results are sent back to the UI thread safely
class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    // We use 'async' here because it's the modern, clean way for Swift 6
    func saveUserProfile(_ profile: UserProfile) async throws {
        let docRef = db.collection("users").document(profile.uid)
        // This converts your struct to Firestore data automatically
        try docRef.setData(from: profile)
    }
    
    func fetchUserProfile(uid: String) async throws -> UserProfile? {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        return try snapshot.data(as: UserProfile.self)
    }
    // Update specific fields in an existing user profile
    func updateUserProfile(uid: String, data: [String: Any]) async throws {
        try await db.collection("users").document(uid).updateData(data)
    }
    
        
    func deleteUserAccount() async throws {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            
            // 1. Scrub all Community Posts, Comments, and Likes
            // We do this FIRST while the user still has permission to edit the database
            try await CommunityService.shared.deleteAllUserData(for: uid)
            
            // 2. Delete Firestore User Profile Data
            try await db.collection("users").document(uid).delete()
            
            // 3. Delete Diary Entries (Optional, but highly recommended for data protection!)
            let diarySnapshot = try await db.collection("diary_entries").whereField("userId", isEqualTo: uid).getDocuments()
            for doc in diarySnapshot.documents {
                try await doc.reference.delete()
            }
            
            // 4. Finally, Delete Auth Account
            try await user.delete()
    }
}
