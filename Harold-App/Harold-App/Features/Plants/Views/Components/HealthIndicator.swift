//
//  HealthIndicator.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct HealthIndicator: View {
    let score: Double
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.healthColor(score: score))
                .frame(width: 12, height: 12)
            
            Text("\(Int(score))%")
                .foregroundColor(Color.healthColor(score: score))
                .font(.caption)
        }
    }
}

//#Preview {
//    HealthIndicator()
//}
