//
//  ChatView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    
    var body: some View {
        VStack {
            // Message list
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message input area
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
        }
        .navigationTitle("Harold AI Chat")
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // Create a user message
        let userMessage = ChatMessage(content: messageText, isUser: true)
        messages.append(userMessage)
        
        // Placeholder for API call
        Task {
            do {
                // Simulate API call (replace with actual API logic)
                let response = try await performAIQuery(message: messageText)
                
                // Add AI response to messages
                let aiMessage = ChatMessage(content: response, isUser: false)
                await MainActor.run {
                    messages.append(aiMessage)
                }
            } catch {
                // Handle error
                let errorMessage = ChatMessage(content: "Error: \(error.localizedDescription)", isUser: false)
                await MainActor.run {
                    messages.append(errorMessage)
                }
            }
            
            // Clear input
            messageText = ""
        }
    }
    
    private func performAIQuery(message: String) async throws -> String {
        // TODO: Implement actual API call to AI service
        // This is a placeholder that simulates an AI response
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        return "This is a sample AI response to: \(message)"
    }
}
