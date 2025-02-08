//
//  Badge.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftData
import Foundation

@Model
final class Badge {
    var id: String
    var name: String
    var desc: String
    var category: BadgeCategory
    var progress: Double
    var isCompleted: Bool
    var earnedAt: Date?
    var deviceId: String
    
    enum BadgeCategory: String, Codable {
        case care = "Plant Care"
        case harvest = "Harvesting"
        case learning = "Education"
        case seasonal = "Seasonal"
        case special = "Special"
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         desc: String,
         category: BadgeCategory,
         deviceId: String = DeviceManager.shared.deviceId) {
        self.id = id
        self.name = name
        self.desc = desc
        self.category = category
        self.progress = 0.0
        self.isCompleted = false
        self.deviceId = deviceId
    }
}
