//
//  LessonDetailView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct LessonDetailView: View {
    let lesson: Lesson
    let course: Course
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var currentContentIndex = 0
    @State private var showingQuizResult = false
    @State private var quizScore = 0.0
    @State private var selectedAnswers: [Int?]
    
    private var quizQuestions: [Lesson.QuizQuestion] {
        lesson.content.compactMap { content in
            if case let .quiz(questions) = content {
                return questions
            }
            return nil
        }.first ?? []
    }
    
    init(lesson: Lesson, course: Course) {
        self.lesson = lesson
        self.course = course
        // Initialize selectedAnswers with nil values matching quiz questions
        let questions = lesson.content.compactMap { content in
            if case let .quiz(questions) = content {
                return questions
            }
            return nil
        }.first ?? []
        
        _selectedAnswers = State(initialValue: Array(repeating: nil, count: questions.count))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(lesson.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(lesson.desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Content display
                contentView
                
                // Navigation and completion buttons
                navigationButtons
            }
            .padding()
        }
        .navigationBarTitle(lesson.title, displayMode: .inline)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if currentContentIndex < lesson.content.count {
            switch lesson.content[currentContentIndex] {
            case .text(let text):
                Text(text)
                    .font(.body)
            case .quiz(let questions):
                quizView(questions: questions)
            }
        }
    }
    
    private func quizView(questions: [Lesson.QuizQuestion]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quiz")
                .font(.headline)
            
            ForEach(questions.indices, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(questions[index].question)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(questions[index].options.indices, id: \.self) { optionIndex in
                        Button(action: {
                            selectedAnswers[index] = optionIndex
                        }) {
                            HStack {
                                Text(questions[index].options[optionIndex])
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if showingQuizResult {
                                    Image(systemName: optionIndex == questions[index].correctAnswer
                                          ? "checkmark.circle.fill"
                                          : (selectedAnswers[index] == optionIndex
                                             ? "xmark.circle.fill"
                                             : "circle"))
                                    .foregroundColor(optionIndex == questions[index].correctAnswer
                                                     ? .green
                                                     : (selectedAnswers[index] == optionIndex
                                                        ? .red
                                                        : .gray))
                                } else {
                                    Image(systemName: selectedAnswers[index] == optionIndex
                                          ? "checkmark.circle.fill"
                                          : "circle")
                                        .foregroundColor(selectedAnswers[index] == optionIndex
                                                         ? .blue
                                                         : .gray)
                                }
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .disabled(showingQuizResult)
                    }
                }
            }
            
            if !showingQuizResult {
                Button("Submit Quiz") {
                    calculateQuizScore(questions)
                }
                .disabled(selectedAnswers.contains(where: { $0 == nil }))
                .buttonStyle(.borderedProminent)
            } else {
                VStack(alignment: .leading) {
                    Text("Quiz Score: \(Int(quizScore * 100))%")
                        .font(.headline)
                        .foregroundColor(quizScore > 0.7 ? .green : .red)
                    
                    Button("Complete Lesson") {
                        do {
                            let viewModel = LearningViewModel(modelContext: modelContext)
                            try viewModel.completeLesson(lesson, in: course)
                            dismiss()
                        } catch {
                            print("Error completing lesson: \(error)")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    private func calculateQuizScore(_ questions: [Lesson.QuizQuestion]) {
        var correctCount = 0
        
        for (index, question) in questions.enumerated() {
            if selectedAnswers[index] == question.correctAnswer {
                correctCount += 1
            }
        }
        
        quizScore = Double(correctCount) / Double(questions.count)
        showingQuizResult = true
    }
    
    @ViewBuilder
    private var navigationButtons: some View {
        HStack {
            if currentContentIndex > 0 {
                Button("Previous") {
                    currentContentIndex -= 1
                }
            }
            
            Spacer()
            
            if currentContentIndex < lesson.content.count - 1 {
                Button("Next") {
                    currentContentIndex += 1
                }
            }
        }
    }
}
