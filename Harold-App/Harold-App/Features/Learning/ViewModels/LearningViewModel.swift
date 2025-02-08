//
//  LearningViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

@Observable
class LearningViewModel {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func completeLesson(_ lesson: Lesson) async throws {
        lesson.isCompleted = true
        lesson.completedAt = Date()
        try modelContext.save()
        
        // Update associated badges
        await BadgeViewModel(modelContext: modelContext)
            .checkAndUpdateBadges()
    }
}
