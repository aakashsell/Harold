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
        case quiz([QuizQuestion]) // Removed .image case
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
