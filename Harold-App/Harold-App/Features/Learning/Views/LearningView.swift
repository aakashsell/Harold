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
    @Query(sort: \Course.courseOrder, order: .forward) private var courses: [Course] // Sort by courseOrder
    @StateObject private var viewModel: LearningViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: LearningViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(courses) { course in
                    CourseRowView(course: course)
                }
            }
            .navigationTitle("Courses")
            .onAppear {
                print("Fetched Courses: \(courses)")
            }
        }
    }
}
