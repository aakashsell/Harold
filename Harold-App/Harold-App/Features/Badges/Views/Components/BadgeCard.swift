//
//  BadgeCard.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack {
            Circle()
                .fill(badge.isCompleted ? .green : .gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
            
            Text(badge.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            if !badge.isCompleted {
                AchievementProgress(progress: badge.progress)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}
