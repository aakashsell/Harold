//
//  DiaryEntryDetailView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/11/25.
//

import SwiftUI

struct DiaryEntryDetailView: View {
    let entry: DiaryEntry
    let plant: Plant
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image section
                if let imageData = entry.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Health Score
                HStack {
                    Text("Health Score")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(entry.healthScore))%")
                        .font(.title2)
                        .foregroundColor(Color.healthColor(score: entry.healthScore))
                }
                
                // Date and Time
                Text(entry.timestamp.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Notes
                Text("Notes")
                    .font(.headline)
                    .padding(.top)
                Text(entry.note)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Diary Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}
