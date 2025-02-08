//
//  BadgeDetailView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct BadgeDetailView: View {
    let badge: Badge
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Circle()
                    .fill(badge.isCompleted ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                    }
                    .padding(.top)
                
                Text(badge.name)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(badge.desc)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if !badge.isCompleted {
                    ProgressIndicator(
                        progress: badge.progress,
                        color: .green
                    )
                    .frame(height: 8)
                    .padding(.horizontal)
                    
                    Text("\(Int(badge.progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if let earnedAt = badge.earnedAt {
                    Text("Earned \(earnedAt.formattedDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Badge Details")
    }
}

#Preview {
    BadgeDetailView()
}
