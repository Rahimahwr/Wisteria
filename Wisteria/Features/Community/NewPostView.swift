//
//  NewPostView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 26/01/2026.
//

import SwiftUI

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    var onPost: (CommunityPost) -> Void
    
    @State private var postContent = ""
    @State private var selectedTags: Set<String> = []
    
    let availableTags = ["Acne-prone", "Rosacea", "Hyperpigmentation", "Eczema", "Sensitive Skin", "Dryness", "Product Review", "Routine Help"]

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.93, blue: 0.95).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("New Post")
                        .font(.custom("Lustria-Regular", size: 28))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What's on your mind?")
                        TextEditor(text: $postContent)
                            .frame(height: 150)
                            .padding(10)
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(15)
                            .overlay(
                                Group {
                                    if postContent.isEmpty {
                                        Text("Share your experience, ask questions...")
                                            .foregroundColor(.gray)
                                            .padding(.leading, 15).padding(.top, 20)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Add tags")
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(availableTags, id: \.self) { tag in
                                Button(action: {
                                    if selectedTags.contains(tag) { selectedTags.remove(tag) }
                                    else { selectedTags.insert(tag) }
                                }) {
                                    Text(tag)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedTags.contains(tag) ? Color.purple.opacity(0.2) : Color.white.opacity(0.4))
                                        .foregroundColor(.black)
                                        .cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.1)))
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Button("Post") {
                            let newPost = CommunityPost(
                                userName: "Rahimah", // Placeholder for current user
                                timeAgo: "Just now",
                                content: postContent,
                                tags: Array(selectedTags)
                            )
                            onPost(newPost)
                            dismiss()
                        }
                        .padding().frame(maxWidth: .infinity)
                        .background(Color(red: 0.3, green: 0.2, blue: 0.25)).foregroundColor(.white).cornerRadius(15)
                        
                        Button("Cancel") { dismiss() }
                        .padding().frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.4)).foregroundColor(.black).cornerRadius(15)
                    }
                }
                .padding(25)
            }
        }
    }
}
