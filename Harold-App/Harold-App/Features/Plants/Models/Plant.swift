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
}

@Model
final class PlantImage {
    var id: String
    var imageData: Data
    var timestamp: Date
    
    @Relationship var plant: Plant?
}
