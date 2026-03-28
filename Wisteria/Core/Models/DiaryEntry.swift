//
//  DiaryEntry.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import Foundation
import FirebaseFirestore

struct DiaryEntry: Identifiable, Codable {
    @DocumentID var id: String? // Firebase will auto-generate this
    let userId: String
    let timestamp: Date
    let mood: String        // "Great", "Okay", "Breaking Out"
    let conditions: [String]
    let products: String
    
    // Logic: Convert the "Mood" to the "Status Label" you want for the list
    var statusLabel: String {
        switch mood {
        case "Great": return "Good"
        case "Breaking Out": return "Bad"
        default: return "Okay"
        }
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: timestamp)
    }
}
