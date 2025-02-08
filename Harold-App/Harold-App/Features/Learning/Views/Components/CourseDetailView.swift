//
//  CourseDetailView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(course.lessons) { lesson in
                LessonRowView(lesson: lesson, course: course)
            }
        }
        .navigationTitle(course.title)
    }
}
