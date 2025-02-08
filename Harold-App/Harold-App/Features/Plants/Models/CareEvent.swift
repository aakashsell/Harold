//
//  CareEvent.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class CareEvent {
    var id: String
    var type: CareType
    var timestamp: Date
    var notes: String?
    
    @Relationship var plant: Plant?
    
    enum CareType: String, Codable {
        case water
        case fertilize
        case prune
        case repot
        case harvest
    }
    
    init(id: String = UUID().uuidString,
         type: CareType,
         notes: String? = nil,
         plant: Plant? = nil) {
        self.id = id
        self.type = type
        self.timestamp = Date()
        self.notes = notes
        self.plant = plant
    }
}

extension CareEvent.CareType: CaseIterable {}
