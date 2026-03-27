import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false

    init() {
        // Check if a user is already signed in when the app starts
        self.isLoggedIn = Auth.auth().currentUser != nil
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isLoggedIn = true
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isLoggedIn = true
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        self.isLoggedIn = false
    }
}