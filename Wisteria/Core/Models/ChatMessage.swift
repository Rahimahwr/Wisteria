//
//  ChatMessage.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    enum Role {
        case user
        case assistant
        case system
    }

    let id = UUID()
    let role: Role
    let text: String
    let createdAt = Date()
}
#Preview {
    ChatMessage(role: .user, text: "Hello, World!")
}