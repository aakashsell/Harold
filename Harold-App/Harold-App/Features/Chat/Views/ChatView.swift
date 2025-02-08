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
        
        let prompt = messageText
        messageText = ""
        
        // Placeholder for API call
        Task {
            do {
                // Simulate API call (replace with actual API logic)
                let response = try await performAIQuery(message: prompt)
                
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
        }
    }
    
    struct AIResponse: Decodable {
        let prompt: String  // Define a struct that matches your JSON structure
        let response: String  // The key "response" must match the JSON
        // Add other properties here for other JSON fields if needed
    }
    
    private func performAIQuery(message: String) async throws -> String {
        // Ensure the URL is valid
        guard let url = URL(string: "https://harold.bazement.net/api/chat/") else {
            throw URLError(.badURL) // Throw an error if the URL is invalid
        }
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the JSON body
        let json: [String: Any] = ["prompt": message]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        // Perform the request using async/awai
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Print the raw response data for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            } else {
                print("Unable to convert data to string. Try a different encoding.")
                throw URLError(.badServerResponse)
            }
            
            // Check the HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            do {
                // Step 1: Decode the response data into a String
                let jsonString = try JSONDecoder().decode(String.self, from: data)
                
                // Step 2: Convert the JSON string back into Data
                guard let jsonData = jsonString.data(using: .utf8) else {
                    throw URLError(.cannotParseResponse)
                }
                
                // Step 3: Decode the JSON data into your AIResponse model
                let decoder = JSONDecoder()
                let aiResponse = try decoder.decode(AIResponse.self, from: jsonData)
                return aiResponse.response
                
            } catch let decodingError as DecodingError {
                print("JSON decoding error: \(decodingError)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)") // Print response for debugging
                }
                throw URLError(.cannotParseResponse)
            } catch {
                print("An unexpected error occurred during JSON processing: \(error)")
                throw URLError(.cannotParseResponse)
            }
            
        } catch let urlError as URLError {
            print("URL Error: \(urlError)")
            throw urlError
        } catch {
            print("An unexpected error occurred: \(error)")
            throw error
        }
        
    }
}
