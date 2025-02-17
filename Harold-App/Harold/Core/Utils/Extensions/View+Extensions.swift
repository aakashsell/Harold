//
//  View+Extensions.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/8/25.
//

import Foundation
import SwiftUICore

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .cornerRadius(12)
            .shadow(radius: 2)
    }
}
