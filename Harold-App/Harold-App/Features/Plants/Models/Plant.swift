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
    var images: [PlantImage]  // Changed from 3D model to images
    var healthScore: Double
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade) var careEvents: [CareEvent]
    @Relationship(deleteRule: .cascade) var diaryEntries: [DiaryEntry]
    
    init(id: String, deviceId: String, name: String, species: String, images: [PlantImage], healthScore: Double, createdAt: Date, updatedAt: Date, careEvents: [CareEvent], diaryEntries: [DiaryEntry]) {
        self.id = id
        self.deviceId = deviceId
        self.name = name
        self.species = species
        self.images = images
        self.healthScore = healthScore
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.careEvents = careEvents
        self.diaryEntries = diaryEntries
    }
}

@Model
final class PlantImage {
    var id: String
    var imageData: Data
    var timestamp: Date
    
    @Relationship var plant: Plant?
    
    init(id: String, imageData: Data, timestamp: Date, plant: Plant? = nil) {
        self.id = id
        self.imageData = imageData
        self.timestamp = timestamp
        self.plant = plant
    }
}
