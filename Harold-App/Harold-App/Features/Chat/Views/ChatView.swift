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
    @FocusState private var isTextFieldFocused: Bool
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Message list
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            
            // Loading indicator
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.bottom, 8)
            }
            
            // Message input area
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)
                    .disabled(isLoading)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(messageText.isEmpty || isLoading ? .gray : .blue)
                }
                .disabled(messageText.isEmpty || isLoading)
                .padding(.trailing)
            }
            .padding(.bottom, 8)
        }
        .navigationTitle("Chat with Harold")
        .gesture(
            DismissKeyboardGesture()
        )
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty, !isLoading else { return }
        
        // Create a user message
        let userMessage = ChatMessage(content: messageText, isUser: true)
        messages.append(userMessage)
        
        let prompt = messageText
        messageText = ""
        isTextFieldFocused = false
        isLoading = true
        
        // API call
        Task {
            do {
                let response = try await performAIQuery(message: prompt)
                
                // Add AI response to messages
                let aiMessage = ChatMessage(content: response, isUser: false)
                await MainActor.run {
                    messages.append(aiMessage)
                    isLoading = false
                }
            } catch {
                // Handle error
                let errorMessage = ChatMessage(
                    content: "Error: \(error.localizedDescription)",
                    isUser: false
                )
                await MainActor.run {
                    messages.append(errorMessage)
                    isLoading = false
                }
            }
        }
    }
    
    private func performAIQuery(message: String) async throws -> String {
        guard let url = URL(string: "https://harold.bazement.net/api/chat/") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["prompt": message]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug logging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            do {
                let jsonString = try JSONDecoder().decode(String.self, from: data)
                
                guard let jsonData = jsonString.data(using: .utf8) else {
                    throw URLError(.cannotParseResponse)
                }
                
                let decoder = JSONDecoder()
                let aiResponse = try decoder.decode(AIResponse.self, from: jsonData)
                return aiResponse.response
                
            } catch {
                print("Decoding error: \(error)")
                throw URLError(.cannotParseResponse)
            }
            
        } catch {
            print("API call error: \(error)")
            throw error
        }
    }
    
    // Nested structs
    struct AIResponse: Decodable {
        let prompt: String
        let response: String
    }
}

// Dismiss keyboard gesture
struct DismissKeyboardGesture: Gesture {
    var body: some Gesture {
        TapGesture().onEnded {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
