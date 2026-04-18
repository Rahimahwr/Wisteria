//
//  CommunityView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import SwiftUI

struct CommunityView: View {
    @StateObject private var viewModel = CommunityViewModel()
    @State private var showNewPost = false
    @State private var selectedPost: CommunityPost? = nil

    var body: some View {
        ZStack {
            Image("backgroundImage").resizable().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection
                    
                    if viewModel.posts.isEmpty {
                        Text("No posts yet. Be the first to share!")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        ForEach(viewModel.posts) { post in
                            postCard(post: post)
                        }
                    }
                    
                    Color.clear.frame(height: 120)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear { viewModel.fetchPosts() }
        .sheet(item: $selectedPost) { postToCommentOn in
            // Pass the post ID so CommentView can refresh it
            CommentView(post: postToCommentOn, currentUserName: viewModel.currentUserName) {
                viewModel.fetchPosts() // Refresh after commenting
            }
        }
        .sheet(isPresented: $showNewPost) {
            NewPostView(userName: viewModel.currentUserName) {
                viewModel.fetchPosts() // Refresh after posting
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Text("Community")
                .font(.custom("Lustria-Regular", size: 32))
            Spacer()
            Button(action: { showNewPost = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.black)
                    .frame(width: 55, height: 55)
                    .background(Color.white.opacity(0.6))
                    .clipShape(Circle())
            }
        }
        .padding(.top, 20)
    }

    private func postCard(post: CommunityPost) -> some View {
        let isLiked = post.likedBy.contains(viewModel.currentUserId)
        
        return VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(post.userName).bold()
                Text(post.timeAgo).font(.caption).foregroundColor(.gray)
            }
            
            Text(post.content)
                .font(.system(size: 15))
                .lineSpacing(4)
            
            // Tags wrap horizontally (using LazyVGrid or ScrollView)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(post.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption).bold()
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
            
            Divider().padding(.vertical, 5)
            
            HStack(spacing: 20) {
                Button(action: { viewModel.toggleLike(for: post) }) {
                    HStack(spacing: 5) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .black)
                        Text("\(post.likedBy.count)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
                
                Button(action: { selectedPost = post }) {
                    HStack(spacing: 5) {
                        Image(systemName: "bubble.right")
                        Text("\(post.comments.count)")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                }
                Spacer()
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.7)))
    }
}
