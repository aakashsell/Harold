//
//  DiaryEntry.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class DiaryEntry {
    var note: String
    var healthScore: Double
    var timestamp: Date
    var plant: Plant?
    var imageData: Data? // New property for diary entry image
    
    init(note: String, healthScore: Double, plant: Plant? = nil, imageData: Data? = nil) {
        self.note = note
        self.healthScore = healthScore
        self.timestamp = Date()
        self.plant = plant
        self.imageData = imageData
    }
}
