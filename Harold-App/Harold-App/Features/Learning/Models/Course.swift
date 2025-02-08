//
//  Course.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//
import Foundation
import SwiftData

@Model
final class Course {
    var id: String
    var title: String
    var desc: String
    var lessons: [Lesson]
    var progress: Double
    var isUnlocked: Bool
    var isCompleted: Bool
    var courseOrder: Int // Add this property to define the order of courses
    
    init(id: String = UUID().uuidString,
         title: String,
         desc: String,
         lessons: [Lesson] = [],
         progress: Double = 0.0,
         isUnlocked: Bool = false,
         isCompleted: Bool = false,
         courseOrder: Int = 0) { // Add courseOrder to the initializer
        self.id = id
        self.title = title
        self.desc = desc
        self.lessons = lessons
        self.progress = progress
        self.isUnlocked = isUnlocked
        self.isCompleted = isCompleted
        self.courseOrder = courseOrder
    }
}
