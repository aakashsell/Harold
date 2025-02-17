//
//  Color+Extensions.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import Foundation

extension Color {    
    static func healthColor(score: Double) -> Color {
        switch score {
        case 90...100: return .green
        case 70..<90: return .yellow
        case 40..<70: return .orange
        default: return .red
        }
    }
}
