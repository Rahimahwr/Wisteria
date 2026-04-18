//
//  CommentView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import SwiftUI

struct CommentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var post: CommunityPost
    @State private var newCommentText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.93, blue: 0.95).ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(post.comments) { comment in
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(comment.userName).bold().font(.system(size: 14))
                                        Text(comment.timeAgo).font(.caption).foregroundColor(.gray)
                                    }
                                    Text(comment.content).font(.system(size: 15))
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(15)
                            }
                        }
                        .padding()
                    }

                    HStack {
                        TextField("Add a comment...", text: $newCommentText)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                        
                        Button(action: postComment) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color(red: 0.3, green: 0.2, blue: 0.25))
                                .clipShape(Circle())
                        }
                        .disabled(newCommentText.isEmpty)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                }
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func postComment() {
        let comment = Comment(
            userName: "Rahimah", // Current user placeholder
            content: newCommentText,
            timeAgo: "Just now"
        )
        post.comments.append(comment)
        newCommentText = ""
    }
}
