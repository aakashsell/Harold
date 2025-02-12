//
//  QuizQuestionView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import SwiftUI

struct QuizQuestionView: View {
    let question: Lesson.QuizQuestion
    @Binding var selectedAnswer: Int?
    @Binding var showingResults: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.question)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            ForEach(question.options.indices, id: \.self) { index in
                Button(action: {
                    if !showingResults {
                        selectedAnswer = index
                    }
                }) {
                    HStack {
                        Text(question.options[index])
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if showingResults {
                            Image(systemName: index == question.correctAnswer
                                  ? "checkmark.circle.fill"
                                  : (selectedAnswer == index
                                     ? "xmark.circle.fill"
                                     : "circle"))
                            .foregroundColor(index == question.correctAnswer
                                             ? .green
                                             : (selectedAnswer == index
                                                ? .red
                                                : .gray))
                        } else {
                            Image(systemName: selectedAnswer == index
                                  ? "checkmark.circle.fill"
                                  : "circle")
                                .foregroundColor(selectedAnswer == index
                                                 ? .blue
                                                 : .gray)
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                .disabled(showingResults)
            }
        }
    }
}

