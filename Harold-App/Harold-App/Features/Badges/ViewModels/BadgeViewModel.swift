//
//  BadgeViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

class BadgeViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    static let predefinedBadges: [Badge] = [
        Badge(name: "Photo Enthusiast",
             desc: "Upload 20 plant photos",
             category: .care),
        Badge(name: "Growth Expert",
             desc: "Graduate from 5+ pot sizes",
             category: .care),
        Badge(name: "Propagator",
             desc: "Propagate an existing plant",
             category: .special),
        Badge(name: "Four Seasons",
             desc: "Care for a plant through all four seasons",
             category: .care),
        // Add all other badges...
    ]
    
    func checkAndUpdateBadges() async {
        // Implement badge progress checking logic
    }
}
