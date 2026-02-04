//
//  CommunityView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import SwiftUI

struct CommunityView: View {
    @State private var showNewPost = false
    // Mock Data for the feed
    @State private var posts = [
        CommunityPost(userName: "Emma R.", timeAgo: "2 hours ago", content: "Just tried the Glossier Skin Tint and it’s amazing for sensitive skin! No irritation at all. Highly recommend for anyone with rosacea", tags: ["Rosacea", "Product Review"]),
        CommunityPost(userName: "Sarah L.", timeAgo: "4 hours ago", content: "Does anyone have recommendations for a good physical sunscreen that doesn't leave a white cast?", tags: ["Sunscreen", "Advice"])
    ]

    var body: some View {
        ZStack {
            Image("backgroundImage").resizable().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection
                    
                    ForEach($posts) { $post in
                        postCard(post: $post)
                    }
                    
                    Color.clear.frame(height: 120) // Space for persistent Navbar
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showNewPost) {
            NewPostView { newPost in
                posts.insert(newPost, at: 0) // Push new post to top of feed
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

    private func postCard(post: Binding<CommunityPost>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(post.wrappedValue.userName).bold()
                Text(post.wrappedValue.timeAgo).font(.caption).foregroundColor(.gray)
            }
            
            Text(post.wrappedValue.content)
                .font(.system(size: 15))
                .lineSpacing(4)
            
            HStack {
                ForEach(post.wrappedValue.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption).bold()
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            
            Divider().padding(.vertical, 5)
            
            HStack(spacing: 20) {
                Button(action: { post.wrappedValue.isLiked.toggle() }) {
                    Image(systemName: post.wrappedValue.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(post.wrappedValue.isLiked ? .red : .black)
                }
                
                Button(action: { /* Comment logic */ }) {
                    Image(systemName: "bubble.right")
                        .foregroundColor(.black)
                }
                
                Spacer()
                // Saved icon removed as per request
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.7)))
    }
}
