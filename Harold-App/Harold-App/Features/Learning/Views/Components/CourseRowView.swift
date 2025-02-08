//
//  CourseRowView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

import SwiftUI

struct CourseRowView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(course.title)
                        .font(.headline)
                    Text(course.desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if !course.isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            ProgressView(value: course.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .padding(.top, 4)
            
            if course.isUnlocked {
                NavigationLink(destination: CourseDetailView(course: course)) {
                    Text("Start Course")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .disabled(!course.isUnlocked)
            }
        }
        .padding()
        .background(course.isUnlocked ? Color.white : Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
