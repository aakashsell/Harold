//
//  HealthStatusView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/11/25.
//

import SwiftUI

struct HealthStatusView: View {
    let plant: Plant
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Plant Health")
                    .font(.headline)
                Spacer()
                Text("\(Int(plant.healthScore))%")
                    .font(.title2)
                    .foregroundColor(Color.healthColor(score: plant.healthScore))
            }
            
            ProgressView(value: plant.healthScore, total: 100)
                .tint(Color.healthColor(score: plant.healthScore))
        }
        .padding()
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
