//
//  CommunityPost.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    var id: String = UUID().uuidString
    let userId: String
    let userName: String
    let content: String
    let timestamp: Date
    
    var timeAgo: String {
        return timestamp.timeAgoDisplay()
    }
}

struct CommunityPost: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let userName: String
    let timestamp: Date
    let content: String
    let tags: [String]
    var likedBy: [String] = [] // Stores User IDs of people who liked it
    var comments: [Comment] = []
    
    var timeAgo: String {
        return timestamp.timeAgoDisplay()
    }
}

// Helper to convert real Dates into "2 hours ago", "Just now", etc.
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
