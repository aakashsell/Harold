//
//  LearningView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct LearningView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var courses: [Course]
    @StateObject private var viewModel: LearningViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(courses) { course in
                    Section(header: Text(course.title)) {
                        ForEach(course.lessons) { lesson in
                            NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                                LessonCard(lesson: lesson)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Learning Path")
        }
    }
}
