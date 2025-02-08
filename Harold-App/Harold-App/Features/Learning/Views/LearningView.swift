//
//  LearningView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct LearningView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: LearningViewModel
    
    // Initialize courses from the view model instead of using @Query
    
    init() {
        _viewModel = StateObject(wrappedValue: LearningViewModel(modelContext: ModelContext()))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.courses) { course in
                    Section(header: Text(course.title)) {
                        ForEach(course.lessons) { lesson in
                            NavigationLink(destination: LessonDetailView(lesson: lesson, viewModel: viewModel)) {
                                LessonCard(lesson: lesson)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Learning Path")
            .onAppear {
                Task {
                    await viewModel.loadCourses()
                }
            }
        }
    }
}
