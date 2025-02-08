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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(questions.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Q\(index + 1): \(questions[index].question)")
                        .font(.headline)
                    
                    ForEach(questions[index].options.indices, id: \.self) { optionIndex in
                        Button {
                            if selectedAnswers.count <= index {
                                selectedAnswers.append(optionIndex)
                            } else {
                                selectedAnswers[index] = optionIndex
                            }
                        } label: {
                            HStack {
                                Image(systemName: selectedAnswers.count > index && selectedAnswers[index] == optionIndex ? "checkmark.circle.fill" : "circle")
                                Text(questions[index].options[optionIndex])
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

//#Preview {
//    QuizView()
//}
