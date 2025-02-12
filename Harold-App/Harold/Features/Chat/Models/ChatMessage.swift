//
//  ChatMessage.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date = Date()
}
