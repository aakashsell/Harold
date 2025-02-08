//
//  Plant.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftData
import Foundation

@Model
final class Plant {
    var id: String
    var deviceId: String
    var name: String
    var species: String
    var stage: PlantStage
    var healthScore: Double
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade) var careEvents: [CareEvent]
    @Relationship(deleteRule: .cascade) var diaryEntries: [DiaryEntry]
    
    init(id: String = UUID().uuidString,
         deviceId: String = DeviceManager.shared.deviceId,
         name: String,
         species: String,
         stage: PlantStage) {
        self.id = id
        self.deviceId = deviceId
        self.name = name
        self.species = species
        self.stage = stage
        self.healthScore = 100.0
        self.createdAt = Date()
        self.updatedAt = Date()
        self.careEvents = []
        self.diaryEntries = []
    }
}
