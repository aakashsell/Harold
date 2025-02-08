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
    var id: String
    var note: String
    var healthScore: Double
    var timestamp: Date
    
    @Relationship var plant: Plant?
    
    init(id: String = UUID().uuidString,
         note: String,
         healthScore: Double,
         plant: Plant? = nil) {
        self.id = id
        self.note = note
        self.healthScore = healthScore
        self.timestamp = Date()
        self.plant = plant
    }
}
