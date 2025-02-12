//
//  PlantDiaryView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/11/25.
//

import SwiftUI

struct PlantDiaryView: View {
    let plant: Plant
    @Binding var showingDiaryEntry: Bool  // For adding new entries
    @State private var selectedEntry: DiaryEntry?  // For viewing existing entries
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Plant Diary")
                    .font(.headline)
                Spacer()
                Button("Add Entry") {
                    showingDiaryEntry = true
                }
            }
            
            ForEach(plant.diaryEntries.sorted { $0.timestamp > $1.timestamp }) { entry in
                Button {
                    selectedEntry = entry
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(entry.timestamp.formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Health: \(Int(entry.healthScore))%")
                                .font(.caption)
                                .foregroundColor(Color.healthColor(score: entry.healthScore))
                        }
                        
                        Text(entry.note)
                            .font(.subheadline)
                            .lineLimit(2)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.haroldBackground)
        .cornerRadius(12)
        .padding(.horizontal)
        .sheet(item: $selectedEntry) { entry in
            NavigationStack {
                DiaryEntryDetailView(entry: entry, plant: plant)
            }
        }
    }
}

// Extension to make DiaryEntry identifiable if it isn't already
extension DiaryEntry: Identifiable {
    public var id: UUID {
        UUID()  // You might want to add a proper id property to DiaryEntry instead
    }
}
