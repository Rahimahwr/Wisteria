//
//  ChatViewModel.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import SwiftUI
internal import Combine

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    var linkedProduct: ProductAnalysis?
    
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    
    func setupInitialMessage(for mode: ChatMode) {
        let greeting = mode == .recommendation
            ? "Hi! I'd love to help you find the perfect products. What are you looking for today?"
            : "Hi! I can help you analyse product ingredients. Just send me a product name or barcode!"
        messages = [Message(content: greeting, isUser: false)]
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMsg = Message(content: inputText, isUser: true)
        messages.append(userMsg)
        let savedInput = inputText
        inputText = ""
        
        // to simulate AI & API processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let mockAnalysis = ProductAnalysis(
                name: "Glow Serum",
                brand: "Wisteria Labs",
                imageUrl: "https://via.placeholder.com/100",
                safetyRating: 85,
                ingredients: [
                    Ingredient(name: "Niacinamide", riskLevel: .low, description: "Great for skin barrier."),
                    Ingredient(name: "Fragrance", riskLevel: .medium, description: "Can be irritating for sensitive skin.")
                ],
                aiSummary: "Based on your Oily skin type, this serum is highly recommended as it contains Niacinamide to regulate sebum."
            )
            
            let aiMsg = Message(
                content: "I've analyzed the ingredients for \(savedInput). You can see the full breakdown below:",
                isUser: false,
                linkedProduct: mockAnalysis 
            )
            
            self.messages.append(aiMsg)
        }
    }
}
