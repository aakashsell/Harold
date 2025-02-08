//
//  LessonDetailView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct LessonDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let lesson: Lesson
    @ObservedObject var viewModel: LearningViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(lesson.content.indices, id: \.self) { index in
                    switch lesson.content[index] {
                    case .text(let text):
                        Text(text)
                            .font(.body)
                            .padding(.horizontal)
                    case .image(let imageName):
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                    case .video(let url):
                        Text("Video: \(url.absoluteString)")
                            .padding(.horizontal)
                    case .quiz(let questions):
                        QuizView(questions: questions)
                    }
                }
                
                if !lesson.isCompleted {
                    Button("Complete Lesson") {
                        Task {
                            try? await viewModel.completeLesson(lesson, modelContext: modelContext)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle(lesson.title)
    }
}
