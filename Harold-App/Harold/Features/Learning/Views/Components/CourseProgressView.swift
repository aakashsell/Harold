//
//  CourseProgressView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct CourseProgressView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Course Progress")
                    .font(.headline)
                Spacer()
                Text("\(Int(course.progress * 100))%")
                    .foregroundColor(.secondary)
            }
            
            ProgressIndicator(progress: course.progress)
        }
        .padding()
        .cornerRadius(12)
    }
}

