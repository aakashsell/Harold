//
//  AddCareEventView.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI
import SwiftData

struct AddCareEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
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
                
                Section("Notes (Optional)") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
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
        
        // Save changes
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save care event: \(error)")
        }
    }
}
