//
//  ChatView.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import SwiftUI

struct ChatView: View {
    let mode: ChatMode
    @StateObject private var viewModel = ChatViewModel()
    @Environment(\.dismiss) var dismiss // This handles the Back button

    var body: some View {
        ZStack {
            Image("backgroundImage")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(viewModel.messages) { message in
                                chatBubble(message: message)
                            }
                        }
                        .padding()
                        .id("bottom")
                    }
                    .onChange(of: viewModel.messages.count) {
                        withAnimation { proxy.scrollTo("bottom") }
                    }
                }
                
                inputBar
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.setupInitialMessage(for: mode) }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: { dismiss() }) {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.black.opacity(0.7))
            }
            
            Text(mode.rawValue)
                .font(.custom("Lustria-Regular", size: 28))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(Color.white.opacity(0.5))
                .edgesIgnoringSafeArea(.top)
        )
    }

    private func chatBubble(message: Message) -> some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .padding(18)
                .background(message.isUser ? Color.purple.opacity(0.2) : Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .foregroundColor(.black)
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
    private var inputBar: some View {
        HStack {
            TextField(mode == .recommendation ? "What are you looking for?" : "Type the product name ...", text: $viewModel.inputText)
                .padding()
            
            Button(action: { viewModel.sendMessage() }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color.gray.opacity(0.6)))
            }
            .padding(.trailing, 10)
        }
        .background(RoundedRectangle(cornerRadius: 35).fill(Color.white.opacity(0.9)))
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
}

