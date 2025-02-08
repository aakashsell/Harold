//
//  AddCareEventView.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI

struct AddCareEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let plant: Plant
    
    @State private var selectedType: CareEvent.CareType = .water
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(CareEvent.CareType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                                .tag(type)
                        }
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Add Event") {
                        addCareEvent()
                    }
                }
            }
            .navigationTitle("Add Care Event")
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
    
    private func addCareEvent() {
        let event = CareEvent(
            type: selectedType,
            notes: notes.isEmpty ? nil : notes,
            plant: plant
        )
        modelContext.insert(event)
        
        // Update badges if needed
        Task {
            await BadgeViewModel(modelContext: modelContext)
                .checkAndUpdateBadges()
        }
        
        dismiss()
    }
}

//#Preview {
//    AddCareEventView()
//}
