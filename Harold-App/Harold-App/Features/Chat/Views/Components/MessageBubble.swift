//
//  MessageBubble.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
