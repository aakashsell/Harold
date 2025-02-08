//
//  LearningViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

class LearningViewModel: ObservableObject {
    @Published private(set) var courses: [Course] = []
    
    func loadCourses(modelContext: ModelContext) async {
        let descriptor = FetchDescriptor<Course>()
        do {
            self.courses = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch courses: \(error)")
        }
    }
    
    func completeLesson(_ lesson: Lesson, modelContext: ModelContext) async throws {
        lesson.isCompleted = true
        lesson.completedAt = Date()
        try modelContext.save()
        
        // Update associated badges
        let badgeViewModel = BadgeViewModel()
        await badgeViewModel.checkAndUpdateBadges(modelContext: modelContext)
    }
}
