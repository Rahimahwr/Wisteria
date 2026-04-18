//
//  CommunityViewModel.swift
//  Wisteria
//
import SwiftUI
import FirebaseAuth

@MainActor
class CommunityViewModel: ObservableObject {
    @Published var posts: [CommunityPost] = []
    @Published var currentUserName: String = "User"
    
    var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    init() {
        fetchCurrentUser()
        fetchPosts()
    }
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Task {
            if let profile = try? await UserService.shared.fetchUserProfile(uid: uid) {
                self.currentUserName = profile.fullName.components(separatedBy: " ").first ?? "User"
            }
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                let fetched = try await CommunityService.shared.fetchPosts()
                self.posts = fetched
            } catch {
                print("Error fetching community posts: \(error)")
            }
        }
    }
    
    func toggleLike(for post: CommunityPost) {
        guard let postId = post.id else { return }
        let isLiked = post.likedBy.contains(currentUserId)
        
        // Optimistic UI update (feels instant to the user)
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            if isLiked {
                posts[index].likedBy.removeAll(where: { $0 == currentUserId })
            } else {
                posts[index].likedBy.append(currentUserId)
            }
        }
        
        // Background update to Firebase
        Task {
            try? await CommunityService.shared.toggleLike(postId: postId, isCurrentlyLiked: isLiked)
        }
    }
}