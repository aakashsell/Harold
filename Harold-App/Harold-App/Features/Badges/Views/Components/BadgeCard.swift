//
//  BadgeCard.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct BadgeCard: View {
    let badge: Badge
    
    private var iconName: String {
        switch badge.category {
        case .care: return "leaf.fill"
        case .harvest: return "basket.fill"
        case .learning: return "book.fill"
        case .seasonal: return "sun.max.fill"
        case .special: return "star.fill"
        }
    }
    
    private var categoryColor: Color {
        switch badge.category {
        case .care: return .green
        case .harvest: return .orange
        case .learning: return .blue
        case .seasonal: return .yellow
        case .special: return .purple
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Badge Icon
            Circle()
                .fill(badge.isCompleted ? categoryColor : Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: iconName)
                        .font(.system(size: 30))
                        .foregroundColor(badge.isCompleted ? .white : .gray)
                }
                .shadow(radius: badge.isCompleted ? 2 : 0)
            
            // Badge Name
            Text(badge.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            // Badge Description
            Text(badge.desc)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)
            
            // Progress Indicator (if not completed)
            if !badge.isCompleted {
                ProgressView(value: badge.progress)
                    .tint(categoryColor)
                    .padding(.horizontal)
                
                Text("\(Int(badge.progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else if let earnedAt = badge.earnedAt {
                Text("Earned \(earnedAt.formattedRelativeTime)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 160, height: 200)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(badge.isCompleted ? categoryColor : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
