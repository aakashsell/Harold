//
//  QuizView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct QuizView: View {
    let questions: [Lesson.QuizQuestion]
    @State private var selectedAnswers: [Int] = []
    @State private var showingResults = false
    
    private var score: Int {
        var correct = 0
        for (index, question) in questions.enumerated() {
            if index < selectedAnswers.count && selectedAnswers[index] == question.correctAnswer {
                correct += 1
            }
        }
        return correct
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(questions.indices, id: \.self) { questionIndex in
                VStack(alignment: .leading, spacing: 12) {
                    Text("Question \(questionIndex + 1)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(questions[questionIndex].question)
                        .font(.title3)
                    
                    VStack(spacing: 8) {
                        ForEach(questions[questionIndex].options.indices, id: \.self) { optionIndex in
                            Button {
                                selectAnswer(questionIndex: questionIndex, answer: optionIndex)
                            } label: {
                                HStack {
                                    Text(questions[questionIndex].options[optionIndex])
                                    Spacer()
                                    if showingResults {
                                        if optionIndex == questions[questionIndex].correctAnswer {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else if selectedAnswers.indices.contains(questionIndex) && selectedAnswers[questionIndex] == optionIndex {
                                            Image(systemName: "x.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    } else if selectedAnswers.indices.contains(questionIndex) && selectedAnswers[questionIndex] == optionIndex {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.secondary.opacity(0.1))
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(showingResults)
                        }
                    }
                }
                
                if questionIndex < questions.count - 1 {
                    Divider()
                }
            }
            
            if selectedAnswers.count == questions.count && !showingResults {
                Button {
                    showingResults = true
                } label: {
                    Text("Check Answers")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            
            if showingResults {
                VStack(spacing: 8) {
                    Text("Quiz Results")
                        .font(.headline)
                    Text("\(score) out of \(questions.count) correct")
                        .foregroundColor(score == questions.count ? .green : .orange)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(16)
    }
    
    private func selectAnswer(questionIndex: Int, answer: Int) {
        if selectedAnswers.count <= questionIndex {
            selectedAnswers.append(answer)
        } else {
            selectedAnswers[questionIndex] = answer
        }
    }
}
