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
    var completedAt: Date?
    var deviceId: String
    
    enum LessonContent: Codable {
        case text(String)
        case image(String)
        case video(URL)
        case quiz([QuizQuestion])
    }
    
    struct QuizQuestion: Codable {
        let question: String
        let options: [String]
        let correctAnswer: Int
    }
    
    init(id: String = UUID().uuidString,
         title: String,
         desc: String,
         content: [LessonContent],
         deviceId: String = DeviceManager.shared.deviceId) {
        self.id = id
        self.title = title
        self.desc = desc
        self.content = content
        self.isCompleted = false
        self.deviceId = deviceId
    }
}
