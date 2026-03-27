import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
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
    var preferredProducts: [String] = []
    
    var setupComplete: Bool = false
}