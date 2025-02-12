//
//  Lesson.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class Lesson {
    var id: String
    var title: String
    var desc: String
    var content: [LessonContent]
    var isCompleted: Bool
    var isUnlocked: Bool
    var completedAt: Date?
    
    enum LessonContent: Codable {
        case text(String)
        case quiz([QuizQuestion])
        
        // Add CodingKeys to handle encoding/decoding
        enum CodingKeys: String, CodingKey {
            case text
            case quiz
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Try to decode text first
            if let textValue = try? container.decode(String.self, forKey: .text) {
                self = .text(textValue)
                return
            }
            
            // Then try to decode quiz
            if let quizValue = try? container.decode([QuizQuestion].self, forKey: .quiz) {
                self = .quiz(quizValue)
                return
            }
            
            // If neither decoding works, throw an error
            throw DecodingError.typeMismatch(LessonContent.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Invalid LessonContent"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .text(let textValue):
                try container.encode(textValue, forKey: .text)
            case .quiz(let quizValue):
                try container.encode(quizValue, forKey: .quiz)
            }
        }
    }
    
    struct QuizQuestion: Codable, Identifiable {
        let id = UUID()
        let question: String
        let options: [String]
        let correctAnswer: Int
    }
    
    init(id: String = UUID().uuidString,
         title: String,
         desc: String,
         content: [LessonContent],
         isCompleted: Bool = false,
         isUnlocked: Bool = false) {
        self.id = id
        self.title = title
        self.desc = desc
        self.content = content
        self.isCompleted = isCompleted
        self.isUnlocked = isUnlocked
    }
}
