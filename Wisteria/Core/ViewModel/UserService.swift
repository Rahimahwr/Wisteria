import FirebaseFirestore
import FirebaseAuth

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    // Save or Update user profile
    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("users").document(profile.uid).setData(from: profile, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    // Fetch user profile (for the AI to use later!)
    func fetchUserProfile(uid: String, completion: @escaping (UserProfile?, Error?) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            let profile = try? snapshot?.data(as: UserProfile.self)
            completion(profile, error)
        }
    }
}