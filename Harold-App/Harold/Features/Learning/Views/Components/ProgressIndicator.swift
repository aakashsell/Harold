//
//  ProgressIndicator.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

import SwiftUI

struct ProgressIndicator: View {
    let progress: Double
    let color: Color
    
    init(progress: Double, color: Color = .blue) {
        self.progress = max(0, min(1, progress))
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(color.opacity(0.2))
                    .frame(width: geometry.size.width, height: 10)
                    .cornerRadius(5)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: 10)
                    .cornerRadius(5)
                    .animation(.easeInOut, value: progress)
            }
        }
        .frame(height: 10)
    }
}
