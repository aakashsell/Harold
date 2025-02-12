//
//  LessonRowView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct LessonRowView: View {
    let lesson: Lesson
    let course: Course
    
    var body: some View {
        NavigationLink(destination: LessonDetailView(lesson: lesson, course: course)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .font(.headline)
                    Text(lesson.desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if lesson.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if !lesson.isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.secondary)
                }
            }
            .opacity(lesson.isUnlocked ? 1.0 : 0.5)
        }
        .disabled(!lesson.isUnlocked) // Disable navigation for locked lessons
    }
}
