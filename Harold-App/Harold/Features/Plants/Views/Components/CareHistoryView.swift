//
//  CareHistoryView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/11/25.
//

import SwiftUI

struct CareHistoryView: View {
    let plant: Plant
    @Binding var showingCareSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Care History")
                    .font(.headline)
                Spacer()
                Button("Add Care Event") {
                    showingCareSheet = true
                }
            }
            
            ForEach(plant.careEvents.sorted { $0.timestamp > $1.timestamp }) { event in
                HStack {
                    Image(systemName: careEventIcon(for: event.type))
                        .foregroundColor(careEventColor(for: event.type))
                    
                    VStack(alignment: .leading) {
                        Text(event.type.rawValue.capitalized)
                            .font(.subheadline)
                        if let notes = event.notes {
                            Text(notes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(event.timestamp.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.haroldBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func careEventIcon(for type: CareEvent.CareType) -> String {
        switch type {
        case .water: return "drop.fill"
        case .fertilize: return "leaf.fill"
        case .prune: return "scissors"
        case .repot: return "arrow.up.forward"
        case .harvest: return "basket.fill"
        }
    }
    
    private func careEventColor(for type: CareEvent.CareType) -> Color {
        switch type {
        case .water: return .blue
        case .fertilize: return .green
        case .prune: return .orange
        case .repot: return .brown
        case .harvest: return .purple
        }
    }
}
