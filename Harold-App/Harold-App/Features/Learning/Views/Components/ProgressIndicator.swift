//
//  ProgressIndicator.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct ProgressIndicator: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                Rectangle()
                    .fill(color)
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width))
            }
        }
        .frame(height: 8)
        .clipShape(Capsule())
    }
}
