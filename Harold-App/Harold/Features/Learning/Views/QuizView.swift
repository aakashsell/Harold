//
//  QuizView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct QuizView: View {
    let questions: [Lesson.QuizQuestion]
    @Binding var selectedAnswers: [Int?]
    @Binding var showingResults: Bool
    @State private var score: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quiz")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(questions.indices, id: \.self) { index in
                QuizQuestionView(
                    question: questions[index],
                    selectedAnswer: Binding(
                        get: { selectedAnswers[index] },
                        set: { selectedAnswers[index] = $0 }
                    ),
                    showingResults: $showingResults
                )
            }
            
            if !showingResults {
                Button("Submit Quiz") {
                    calculateScore()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedAnswers.contains(where: { $0 == nil }))
            } else {
                VStack(alignment: .leading) {
                    Text("Score: \(Int(score * 100))%")
                        .font(.headline)
                        .foregroundColor(score > 0.7 ? .green : .red)
                }
            }
        }
    }
    
    private func calculateScore() {
        var correctCount = 0
        
        for (index, question) in questions.enumerated() {
            if selectedAnswers[index] == question.correctAnswer {
                correctCount += 1
            }
        }
        
        score = Double(correctCount) / Double(questions.count)
        showingResults = true
    }
}
