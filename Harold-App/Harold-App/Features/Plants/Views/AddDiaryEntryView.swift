//
//  AddDiaryEntryView.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI

struct AddDiaryEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let plant: Plant
    
    @State private var note: String = ""
    @State private var healthScore: Double = 100
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Health Score") {
                    Slider(value: $healthScore, in: 0...100, step: 1) {
                        Text("Health Score")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    Text("Current Score: \(Int(healthScore))")
                        .foregroundColor(Color.healthColor(score: healthScore))
                }
                
                Section("Notes") {
                    TextEditor(text: $note)
                        .frame(height: 150)
                }
                
                Section {
                    Button("Add Entry") {
                        addDiaryEntry()
                    }
                    .disabled(note.isEmpty)
                }
            }
            .navigationTitle("Add Diary Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addDiaryEntry() {
        let entry = DiaryEntry(
            note: note,
            healthScore: healthScore,
            plant: plant
        )
        modelContext.insert(entry)
        plant.healthScore = healthScore
        
        // Update badges if needed
        Task {
            await BadgeViewModel(modelContext: modelContext)
                .checkAndUpdateBadges()
        }
        
        dismiss()
    }
}

//#Preview {
//    AddDiaryEntryView()
//}
