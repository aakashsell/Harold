//
//  PlantStage.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation

enum PlantStage: String, Codable {
    case seed
    case seedling
    case juvenile
    case mature
    case flowering
    case fruiting
    
    var modelName: String {
        "plant_model_\(self.rawValue)"
    }
}
